//
//  NewsListRouter.swift
//  NewsTFS
//
//  Created by Александр Джегутанов on 2/3/23.
//

protocol NewsListRouterProtocol: AnyObject {
    var presenter: NewsListPresentationProtocol? {get set}
    
    func goToDetailViewController(model: NewsListModel.List)
}

final class NewsListRouter: NewsListRouterProtocol {
    
    weak var presenter: NewsListPresentationProtocol?
    
    lazy var navPush = presenter?.viewController?.navigationController
    
    func goToDetailViewController(model: NewsListModel.List) {
        let vc = NewsDetailViewController(newsModel: model)
        navPush?.pushViewController(vc, animated: true)
    }
}
