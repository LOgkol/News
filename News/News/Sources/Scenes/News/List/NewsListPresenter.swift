//
//  NewsListPresenter.swift
//  NewsTFS
//
//  Created by Александр Джегутанов on 2/3/23.
//

import UIKit

protocol NewsListPresentationProtocol: AnyObject {
    var viewController: NewsListDisplayLogic? {get set}
    var router: NewsListRouterProtocol? {get set}
    
    func checkingDataOnDisk()
    func loadNewsList()
    func updateNewsData()
    func getModel(indexPath: Int) -> NewsListModel.News?
    func getCounterModel() -> Int?
    func goToNewsDetail(indexPath: Int)
}

final class NewsListPresenter: NewsListPresentationProtocol {
    
    //MARK: - MVP Properties
    
    weak var viewController: NewsListDisplayLogic?
    var router: NewsListRouterProtocol?
    
    //MARK: - Network Service
    
    let newsNetworkService = NewsNetworkManager()
    
    //MARK: - Data variables
    
    private var isLoading = false
    private var isAllNewsLoaded = false
    private var totalResults: Int = 0
    private var newsModel: [NewsListModel.News] = []
    
    private var limit: Int = 5
    private var offset: Int = 1
    
    // MARK: - Delegate Methods
    
    func checkingDataOnDisk() {
        if let data = StorageManager.shared.readingData(), data.count > 0 {
            DispatchQueue.main.async {
                self.newsModel = data
                self.offset = self.newsModel.count / 5 + 1
                self.viewController?.showFirstNews()
            }
        } else {
            loadNewsList()
        }
    }
    
    func loadNewsList() {
        guard !isLoading, !isAllNewsLoaded else { return }
        isLoading = true
        if !newsModel.isEmpty {
            viewController?.startFooterTableSpinner()
        }
        getNewsList(limit: limit, offset: offset)
    }
    
    func updateNewsData() {
        isLoading = true
        let limit = newsModel.count
        let offset = 1
        getNewsList(limit: limit, offset: offset, IsThisAnUpdateData: true)
    }
    
    func getModel(indexPath: Int) -> NewsListModel.News? {
        return newsModel[indexPath]
    }
    
    func getCounterModel() -> Int? {
        return newsModel.count
    }
    
    func goToNewsDetail(indexPath: Int) {
        self.newsModel[indexPath].numberOfNewsViews += 1
        let model = newsModel[indexPath]
        router?.goToDetailViewController(model: model)
        StorageManager.shared.saveData(model: newsModel)
    }
}

//MARK: - Private Methods

private extension NewsListPresenter {
    
    //MARK: - Network
    func getNewsList(limit: Int, offset: Int, IsThisAnUpdateData: Bool = false) {
        let requestModel = NewsListModel.RequestNewsModel(limit: limit, offset: offset)
        NewsNetworkManager.shared.getNews(requestModel: requestModel) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if let list = response.articles, list.count > 0 {
                    DispatchQueue.main.async {
                        self.checkingForUpdates(model: list, IsThisAnUpdateData)
                        self.totalResults = response.totalResults ?? 5
                        self.isLoading = false
                    }
                } else {
                    DispatchQueue.main.async {
                        self.noResult()
                        self.isLoading = false
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.viewController?.showAlertRequestError(message: error.localizedDescription)
                    self.isLoading = false
                }
            }
        }
    }
    
    //MARK: - setupModel
    
    func checkingForUpdates(model: [NewsListModel.ResponseNetworkModel.List], _ IsThisAnUpdateData: Bool = false) {
        let model = createArrayWithData(model: model)
        switch IsThisAnUpdateData {
        case true:
            setupModelUpdateData(model: model)
        case false:
            setupModel(model: model)
        }
    }
    
    func setupModelUpdateData(model: [NewsListModel.News]) {
        self.newsModel = model
        viewController?.updateView()
    }
    
    func setupModel(model: [NewsListModel.News]) {
        switch newsModel.isEmpty {
        case true:
            self.newsModel = model
            viewController?.showFirstNews()
            StorageManager.shared.saveData(model: newsModel)
        case false:
            newsModel += model
            viewController?.updateView()
            StorageManager.shared.saveData(model: newsModel)
        }
        
        if newsModel.count == totalResults {
            isAllNewsLoaded = true
        }
        
        offset += 1
    }
    
    func noResult() {
        switch newsModel.isEmpty {
        case true:
            viewController?.showNoResultView()
        case false:
            isAllNewsLoaded = true
            viewController?.stopFooterTableSpinner()
            viewController?.updateView()
        }
    }
    
    func createArrayWithData(model: [NewsListModel.ResponseNetworkModel.List]) -> [NewsListModel.News] {
        var newsModel: [NewsListModel.News] = []
        for item in model {
            let news = NewsListModel.News(sourceName: item.source?.name, title: item.title, description: item.description, url: item.url, urlToImage: item.urlToImage, date: item.date, numberOfNewsViews: 0)
            newsModel.append(news)
        }
        return newsModel
    }
}
