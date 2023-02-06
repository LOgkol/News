//
//  NewsDetailViewController.swift
//  NewsTFS
//
//  Created by Александр Джегутанов on 2/5/23.
//

import UIKit

protocol UpdateNewsList: AnyObject {
    func updateData()
}

protocol NewsDetailDisplayLogic: UIViewController {
    var presenter: NewsDetailPresentationProtocol? {get set}
}

final class NewsDetailViewController: UIViewController, NewsDetailDisplayLogic {
    
    //MARK: - MVP Properties
    
    var presenter: NewsDetailPresentationProtocol?
    
    weak var delegate: UpdateNewsList?
    
    //MARK: - UI properties

    private var contentViewNewsDetail: NewsDetailContentView {
        return self.view as! NewsDetailContentView
    }
    
    // MARK: - Init
    
    convenience init(newsModel: NewsListModel.News) {
        self.init()
        selfConfigurate(newsModel: newsModel)
    }
  
    //MARK: - View lifecycle
    
    override func loadView() {
        self.view = NewsDetailContentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.updateData()
    }
}

//MARK: - Private Methods

private extension NewsDetailViewController {
    
    // MARK: - Self configurate
    
    func selfConfigurate(newsModel: NewsListModel.News? = nil) {
        let assembly = NewsDetailAssembly()
        assembly.configurate(self, newsModel: newsModel)
    }
    
    //MARK: - setupUI
    
    func setupUI() {
        contentViewNewsDetail.delegate = self
        guard let model = presenter?.getModel() else { return }
        contentViewNewsDetail.convigureView(model: model)
    }
}

//MARK: - NewsDetailContentViewProtocol

extension NewsDetailViewController: NewsDetailContentViewProtocol {
    
    func openWebView() {
        presenter?.goToOpenWebView()
    }
}
