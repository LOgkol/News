//
//  NewsListAssembly.swift
//  NewsTFS
//
//  Created by Александр Джегутанов on 2/3/23.
//

final class NewsListAssembly {
    
    func configurate(_ vc: NewsListDisplayLogic) {
        let presenter = NewsListPresenter()
        let router = NewsListRouter()
        vc.presenter = presenter
        presenter.viewController = vc
        presenter.router = router
        router.presenter = presenter
    }
}
