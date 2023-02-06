//
//  NewsListModels.swift
//  NewsTFS
//
//  Created by Александр Джегутанов on 2/3/23.
//

import Foundation

enum NewsListModel {

    struct News: Decodable {
        let articles: [List]?
        let totalResults: Int?
    }

    struct List: Decodable {
        let source: Source?
        let title: String?
        let description: String?
        let url: URL?
        let urlToImage: URL?
        let date: String?
        var numberOfNewsViews = 0
        
        enum CodingKeys: String, CodingKey {
            case source = "source"
            case title = "title"
            case description = "description"
            case url = "url"
            case urlToImage = "urlToImage"
            case date = "publishedAt"
        }
    }
    
    struct Source: Codable {
        let name: String?
    }
    
    struct NewsRequestModel: Codable {
        let limit: Int
        let offset: Int
    }
}
