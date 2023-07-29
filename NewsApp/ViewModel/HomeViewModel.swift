//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Иван Москалев on 25.07.2023.
//

import Foundation

class HomeViewModel {
    
    private var service: NewsRequestServices = NewsRequestServices()
    
    private var loading: Bool = false {
        didSet {
            self.bindLoadingNews?(loading)
        }
    }
    
    var news: [Article] =  [] {
        didSet {
            //print(news)
            self.bindNewsModel?(news)
        }
    }
    
    var bindNewsModel: ( ([Article]) -> () )?
    var bindLoadingNews: ( (Bool) -> () )?

//    init() {
//        let testArticles: Article = .init(source: .init(id: "", name: ""),
//                                          author: "RBK vesti",
//                                          title: "text text texttetexttexttext",
//                                          description: "",
//                                          url: nil, urlToImage: nil, publishedAt: "28.07.2023T23:00",
//                                          content: nil)
//        news.append(testArticles)
//    }
    
    func getNews(category: TagCategory) {
        loading = true
        service.getNews(category: category) { model in
            self.news = model
            self.loading = false
        }
    }
    
    func getSearchNews(with text: String) {
        loading = true
        service.getSearchNews(with: text) { model in
            self.news = model
            self.loading = false
        }
    }
}
