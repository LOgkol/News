//
//  NewsDetailViewController.swift
//  NewsTFS
//
//  Created by Александр Джегутанов on 2/5/23.
//

import UIKit

protocol NewsDetailDisplayLogic: UIViewController {
    var presenter: NewsDetailPresentationProtocol? {get set}
    
}

final class NewsDetailViewController: UIViewController, NewsDetailDisplayLogic {
    
    //MARK: - MVP Properties
    
    var presenter: NewsDetailPresentationProtocol?
    
    //MARK: - UI properties

    private var contentViewNewsDetail: NewsDetailContentView {
        return self.view as! NewsDetailContentView
    }
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(newsModel: NewsListModel.List) {
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
}

//MARK: - Private Methods

private extension NewsDetailViewController {
    
    // MARK: - Self configurate
    
    func selfConfigurate(newsModel: NewsListModel.List? = nil) {
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
