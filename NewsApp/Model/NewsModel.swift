//
//  NewsModel.swift
//  NewsApp
//
//  Created by Иван Москалев on 25.07.2023.
//

import Foundation

enum TagCategory: Int {
    case all
    case technology
    case science
    case business
    case entertainment
    case health
    case sports
}

//// MARK: - NewsModels
//struct NewsModel: Codable {
//    let status: String
//    let totalResults: Int
//    let articles: [Article]
//}
//// MARK: - Article
//struct Article: Codable {
//    let source: Source
//    let author, title: String
//    let description: String?//JSONNull?
//    let url: String
//    let urlToImage: String?//JSONNull?
//    let publishedAt: Date
//    let content: String?//JSONNull?
//
//}
//// MARK: - Source
//struct Source: Codable {
//    let id: String//ID
//    let name: String//Name
//}
//
//enum ID: String, Codable {
//    case googleNews = "google-news"
//}
//
//enum Name: String, Codable {
//    case googleNews = "Google News"
//}
//
//// MARK: - Encode/decode helpers
//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}





struct NewsModel: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]
    
    private enum CodingKeys: String, CodingKey {
        case status
        case totalResults
        case articles
    }
}

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: String?//URL?
    let urlToImage: String?//URL?
    let publishedAt: String?//Date
    let content: String?
    
    struct Source: Codable {
        let id: String?
        let name: String?
    }
}
