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
    
    func loadNewsList()
    func updateNewsData()
    func getModel(indexPath: Int) -> NewsListModel.List?
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
    private var newsModel: [NewsListModel.List] = []
    
    private var limit: Int = 5
    private var offset: Int = 1
    
    // MARK: - Delegate Methods
    
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
        updateData(limit: limit, offset: offset)
        print("limit: \(limit), offset: \(offset)")
    }
    
    func getModel(indexPath: Int) -> NewsListModel.List? {
        return newsModel[indexPath]
    }
    
    func getCounterModel() -> Int? {
        return newsModel.count
    }
    
    func goToNewsDetail(indexPath: Int) {
        self.newsModel[indexPath].numberOfNewsViews += 1
        let model = newsModel[indexPath]
        router?.goToDetailViewController(model: model)
        viewController?.updateView()
    }
}

//MARK: - Private Methods

private extension NewsListPresenter {
    
    //MARK: - Network
    //TODO: Здесь отрабатывает первый запрос в сеть и дальнейшая пагинация
    func getNewsList(limit: Int, offset: Int) {
        let requestModel = NewsListModel.NewsRequestModel(limit: limit, offset: offset)
        newsNetworkService.getNewsList(requestModel: requestModel) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if let list = response.articles, list.count > 0 {
                    DispatchQueue.main.async {
                        self.totalResults = response.totalResults ?? 10
                        self.setupModel(model: list)
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
                    //если сюда частенько падает попробуйте поменять apiKey in NewsNetworkManager
                    //если проблема не исчезнет пожалуйста свяжитесь со мной //telegram: @LOgkol
                    self.viewController?.showAlertRequestError(message: error.localizedDescription)
                    self.isLoading = false
                }
            }
        }
    }
    
    //TODO: тут отрабатывается именно рефреш контрол ( обновление даты )
    // да можно сделать лучше, вынести этот запрос, но дедлайн и работа не оставляют выбора, лучше конечно потом переделать
    //Я не успел прикрутить coreData, думал на всякий сохранять в userDefaults, но я изначально выбрал не правильный вектор а именно в сетевую модель закинул numberOfNewsViews хотя она не прилетает с бека ( думал в ней хранить кол-ва просмотров ), но я забыл что userDefaults декодит данные и просто не сможет декодить эту переменную  и будет ставить 0. Был бы еще денек)))))
    func updateData(limit: Int, offset: Int) {
        let requestModel = NewsListModel.NewsRequestModel(limit: limit, offset: offset)
        newsNetworkService.getNewsList(requestModel: requestModel) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
//                print(response.articles?.count)
                if let list = response.articles, list.count > 0 {
                    DispatchQueue.main.async {
                        self.setupModelUpdateData(model: list)
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
    
    func setupModelUpdateData(model: [NewsListModel.List]) {
        self.newsModel = model
        viewController?.updateView()
    }
    
    func setupModel(model: [NewsListModel.List]) {
        switch newsModel.isEmpty {
        case true:
            self.newsModel = model
            viewController?.showFirstNews()
        case false:
            newsModel += model
            viewController?.updateView()
        }
        
        if newsModel.count == totalResults {
            isAllNewsLoaded = true
        }
        
        offset += 1
        print("limit: \(limit), offset: \(offset)")
    }
    
    func noResult() {
        switch newsModel.isEmpty {
        case true:
            viewController?.showNoResultView()
        case false:
            isAllNewsLoaded = true // я не понимаю как работает пагинация на бэке, т.е 2-3 запроса отправляет по паре новостей и на след запросы прилетает nil... по этому решил еще тут отслеживать состояние. Вообще в идеале чтобы бек присылал просто меньше чем просим и мониторить в другом месте, Но возможно я ошибаюсь :)
            viewController?.stopFooterTableSpinner()
            viewController?.updateView()
        }
    }
}
