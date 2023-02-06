//
//  NewsDetailAssembly.swift
//  NewsTFS
//
//  Created by Александр Джегутанов on 2/5/23.
//

final class NewsDetailAssembly {
    
    func configurate(_ vc: NewsDetailDisplayLogic, newsModel: NewsListModel.News? = nil) {
        let presenter = NewsDetailPresenter(newsModel: newsModel)
        let router = NewsDetailRouter()
        vc.presenter = presenter
        presenter.viewController = vc
        presenter.router = router
        router.presenter = presenter
    }
}
