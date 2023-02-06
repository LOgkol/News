//
//  NewsDetailPresenter.swift
//  NewsTFS
//
//  Created by Александр Джегутанов on 2/5/23.
//

import Foundation

protocol NewsDetailPresentationProtocol: AnyObject {
    var viewController: NewsDetailDisplayLogic? {get set}
    var router: NewsDetailRouterProtocol? {get set}
    
    func getModel() -> NewsListModel.News?
    func goToOpenWebView()
}

final class NewsDetailPresenter: NewsDetailPresentationProtocol {
    
    //MARK: - MVP Properties
    
    weak var viewController: NewsDetailDisplayLogic?
    var router: NewsDetailRouterProtocol?
    
    //MARK: - Init
    
    init(newsModel: NewsListModel.News?) {
        self.newsModel = newsModel
    }

    //MARK: - Data variables

    private var newsModel: NewsListModel.News?

    // MARK: - Delegate Methods

    func getModel() -> NewsListModel.News? {
        return newsModel
    }

    func goToOpenWebView() {
        guard let url = newsModel?.url else { return }
        router?.openWebView(url: url)
    }
}
