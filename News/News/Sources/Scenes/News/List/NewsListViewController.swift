//
//  NewsListViewController.swift
//  NewsTFS
//
//  Created by Александр Джегутанов on 2/3/23.
//

import UIKit

protocol NewsListDisplayLogic: UIViewController {
    var presenter: NewsListPresentationProtocol? {get set}
    
    func showFirstNews()
    func updateView()
    func showNoResultView()
    func startFooterTableSpinner()
    func stopFooterTableSpinner()
    func showAlertRequestError(message: String)
}

final class NewsListViewController: UIViewController {
    
    //MARK: - MVP Properties
    
    var presenter: NewsListPresentationProtocol?
    
    //MARK: - UI properties
    
    private let tableView = UITableView()
    private let refreshControll = UIRefreshControl()
    private let bottomTableSpinner = UIActivityIndicatorView()
    
    private let noResultView = NoResultsView(type: .withoutFilter)
    private let errorView = NoResultsView(type: .errorRequest)

    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        selfConfigurate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        selfConfigurate()
    }
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.loadNewsList()
    }
}

//MARK: - @objc method

@objc private extension NewsListViewController {
    
    func refresh(sender: UIRefreshControl) {
        presenter?.updateNewsData()
    }
}

//MARK: - Private Methods

private extension NewsListViewController {
    
    // MARK: - Self configurate
    
    func selfConfigurate() {
        let assembly = NewsListAssembly()
        assembly.configurate(self)
    }
    
    //MARK: - setupUI
    
    func setupUI() {
        addViews()
        makeConstraints()
        setupViews()
        setupAction()
        startActifitiIndicator()
    }
    
    func addViews() {
        view.addSubview(tableView)
        view.addSubview(noResultView)
        view.addSubview(errorView)
    }
    
    func makeConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        noResultView.translatesAutoresizingMaskIntoConstraints = false
        noResultView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        noResultView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        noResultView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        noResultView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    //MARK: - setupViews
    
    func setupViews() {
        setupSpiner()
        setupTableView()
        view.backgroundColor = .white
        tableView.backgroundColor = .white
        self.title = "News"
    }
    
    func setupTableView() {
        tableView.refreshControl = refreshControll
        tableView.tableFooterView = bottomTableSpinner
        bottomTableSpinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
    }
    
    func setupSpiner() {
        bottomTableSpinner.color = NewsTFSColor.oceanBoatBlue
        bottomTableSpinner.hidesWhenStopped = true
        bottomTableSpinner.style = .large
    }
    
    func startActifitiIndicator() {
        addActivityIndicator(to: .center, needToStart: true, needToDisableUserInteractions: true)
        errorView.isHidden  = true
        noResultView.isHidden = true
        tableView.isHidden = true
    }
    
    //MARK: - Action
    
    func setupAction() {
        refreshControll.addTarget(self, action: #selector(refresh(sender: )), for: .valueChanged)
    }
}

//MARK: - NewsDisplayLogic extension

extension NewsListViewController: NewsListDisplayLogic {

    func showFirstNews() {
        stopAndRemoveActivityIndicator()
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func updateView() {
        stopFooterTableSpinner()
        refreshControll.endRefreshing()
        tableView.reloadData()
    }
    
    func showNoResultView() {
        stopAndRemoveActivityIndicator()
        noResultView.isHidden = false
    }
    
    func startFooterTableSpinner() {
        bottomTableSpinner.startAnimating()
        tableView.tableFooterView?.isHidden = false
    }
    
    func stopFooterTableSpinner() {
        tableView.tableFooterView?.isHidden = true
        bottomTableSpinner.stopAnimating()
    }
    
    func showAlertRequestError(message: String) {
        stopAndRemoveActivityIndicator()
        
        let tryAgain = UIAlertAction(title: "Повторить", style: .default) {_ in
            self.startActifitiIndicator()
            self.presenter?.loadNewsList()
        }
        
        let okAction = UIAlertAction(title: "ОК", style: .default) {_ in
            self.errorView.isHidden = false
        }
        showAlert(title: "Error", message: message, actionArray: [tryAgain, okAction])
    }
}

//MARK: - UITableViewDataSource

extension NewsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getCounterModel() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell,
              let model = presenter?.getModel(indexPath: indexPath.row) else { return UITableViewCell() }
        cell.configureView(model)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension NewsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.goToNewsDetail(indexPath: indexPath.row)
    }
}

//MARK: - UIScrollViewDelegate

extension NewsListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height {
            presenter?.loadNewsList()
        }
    }
}
