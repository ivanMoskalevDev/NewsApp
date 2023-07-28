//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Иван Москалев on 25.07.2023.
//

import Foundation

class HomeViewModel {
    
    private var service: NewsRequestServices = NewsRequestServices()
    
    var news: [Article] =  [] {
        didSet {
            //print(news)
            self.bindNewsModel?(news)
        }
    }
    
    var bindNewsModel: ( ([Article]) -> () )?

    init() {
        let testArticles: Article = .init(source: .init(id: "", name: ""),
                                          author: "RBK vesti",
                                          title: "text text texttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttext",
                                          description: "",
                                          url: nil, urlToImage: nil, publishedAt: "28.07.2023T23:00",
                                          content: nil)
        
        print("tag=\(TagCategory.technology) | \(TagCategory.technology.rawValue)")
        news.append(testArticles)
    }
    
    func getNews(category: TagCategory) {
        service.getNews(category: category) { model in
            self.news = model
        }
    }
}
