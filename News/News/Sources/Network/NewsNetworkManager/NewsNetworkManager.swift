//
//  NewsNetworkManager.swift
//  News
//
//  Created by Александр Джегутанов on 2/6/23.
//

import Foundation

final class NewsNetworkManager {
    
    // MARK: - Private properties
    
    private let apiKey = "3110987608dd4d3d9b95b5c7bc573c57"
    private let mainURL = "https://newsapi.org/v2/everything?q=keyword&apiKey="
    private let session = URLSession(configuration: .default)
    
    // MARK: - Public properties
    
    static let shared = NewsNetworkManager()
    
    // MARK: - Public methods

    func getNews(requestModel: NewsListModel.RequestNewsModel, completion: @escaping (Result<NewsListModel.ResponseNetworkModel.News, Error>) -> Void) {
        getRequest(requestModel: requestModel) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Private methods

private extension NewsNetworkManager {
    
    func getRequest(requestModel: NewsListModel.RequestNewsModel, completion: @escaping (Result<NewsListModel.ResponseNetworkModel.News, Error>) -> Void) {
        let urlString = mainURL + apiKey + "&page=\(requestModel.offset)&pageSize=\(requestModel.limit)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
            return
        }
        
        fetchData(from: url) { (result) in
            switch result {
            case .success(let data):
                self.decodeData(data: data, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
    }
    
    func decodeData<T: Decodable>(data: Data, completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedData))
        } catch let jsonError {
            completion(.failure(jsonError))
        }
    }
}

