//
//  NewsDetailRouter.swift
//  NewsTFS
//
//  Created by Александр Джегутанов on 2/5/23.
//

import Foundation

protocol NewsDetailRouterProtocol: AnyObject {
    var presenter: NewsDetailPresentationProtocol? {get set}
    
    func openWebView(url: URL)
}

final class NewsDetailRouter: NewsDetailRouterProtocol {
    
    weak var presenter: NewsDetailPresentationProtocol?
    
    lazy var navPush = presenter?.viewController?.navigationController
    
    func openWebView(url: URL) {
        let vc = WebViewController(titleNavBar: "Полный текст")
        vc.setupURL(url: url)
        navPush?.pushViewController(vc, animated: true)
    }
}
