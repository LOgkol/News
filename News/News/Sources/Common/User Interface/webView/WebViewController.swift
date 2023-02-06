//
//  WebViewController.swift
//  NewsTFS
//
//  Created by Александр Джегутанов on 2/5/23.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    //MARK: - UI properties
    
    private let webView = WKWebView()
    
    //MARK: - Data variables
    
    private let titleNavBar: String?
    
    //MARK: - Init
    
    init(titleNavBar: String?) {
        self.titleNavBar = titleNavBar
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Deinit
    
    deinit {
        WebViewsHelper.cleanWebView()
    }
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        makeConstraints()
        setupViews()
    }
    
    //MARK: - Publick method
    
    func setupURL(url: URL) {
        setupWKWebView(url: url)
    }
}

//MARK: - Private methods

private extension WebViewController {
    
    //MARK: - addViews
    
    func addViews() {
        view.addSubview(webView)
    }
    
    //MARK: - makeConstraints
    
    func makeConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: - setupViews
    
    func setupViews() {
        title = titleNavBar
        view.backgroundColor = .white
        
        addActivityIndicator(to: .center, needToStart: true)
        webView.isHidden = true
    }
    
    //MARK: - setupWKWebView
    
    func setupWKWebView(url: URL) {
        webView.navigationDelegate = self
        webView.clipsToBounds = true
        webView.load(URLRequest(url: url))
    }
}

//MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopAndRemoveActivityIndicator()
        webView.isHidden = false
    }
}

