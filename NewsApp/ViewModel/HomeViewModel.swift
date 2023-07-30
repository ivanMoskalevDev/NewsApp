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
    
    var newsCellModel: [NewsCellModel] =  [] {
        didSet {
            self.bindNewsModel?(newsCellModel)
        }
    }
    
    var bindNewsModel:   ( ([NewsCellModel]) -> () )?
    var bindLoadingNews: ( (Bool) -> () )?

    init() {
        let testArticles: Article = .init(source: .init(id: "", name: ""),
                                          author: "RBK vesti RBK vesti RBK vesti RBK vesti RBK vesti RBK vesti",
                                          title: "text text texttetexttexttext",
                                          description: "",
                                          url: nil, urlToImage: nil, publishedAt: "28.07.2023T23:00",
                                          content: nil)
        self.newsCellModel.append(.init(newsModel: testArticles, isFavorite: false))
    }
    
    func getNews(category: TagCategory) {
        self.newsCellModel.removeAll()
        loading = true
        service.getNews(category: category) { model in
            for i in 0..<model.count {
                self.newsCellModel.append(.init(newsModel: model[i], isFavorite: false))
            }
            self.loading = false
        }
    }
    
    func getSearchNews(with text: String) {
        self.newsCellModel.removeAll()
        loading = true
        service.getSearchNews(with: text) { model in
            for i in 0..<model.count {
                self.newsCellModel.append(.init(newsModel: model[i], isFavorite: false))
            }
            self.loading = false
        }
    }
}
