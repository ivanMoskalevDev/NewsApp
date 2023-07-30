//
//  NewsRequestServices.swift
//  NewsApp
//
//  Created by Иван Москалев on 25.07.2023.
//

import Foundation

class NewsRequestServices {
    
    private let ApiKey = "eb68bf7b53034f73b43599e1d339bd46"
    private var strURL = "url"
    
    func getNews(category: TagCategory, completion: @escaping ([Article]) -> Void) {

        switch category {
        case .all:
            strURL = "https://newsapi.org/v2/top-headlines?country=ru&apiKey=\(ApiKey)"
        default:
            strURL = "https://newsapi.org/v2/top-headlines?country=ru&category=\(category)&apiKey=\(ApiKey)"
        }
        
        guard let url = URL(string: strURL) else {
            completion([])
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            //response - статус или ошибка
            //error - ошибка детальнее
            if error != nil {
                print("Error requesr: \(error)")
            } else if let data = data, let response = response as? HTTPURLResponse {
                print("statuscode: \(response.statusCode) data: \(data)")
                do {
                    let result = try JSONDecoder().decode(NewsModel.self, from: data)
                    //print(result)
                    completion(result.articles)
                } catch {
                    //print(error)
                    print("Failed connect to \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    
    func getSearchNews(with text: String, completion: @escaping ([Article]) -> Void) {
        let text = text.replacingOccurrences(of: " ", with: "+")
        strURL = "https://newsapi.org/v2/everything?q=\(text)&sortBy=popularity&apiKey=\(ApiKey)"

        guard let url = URL(string: strURL) else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print("Error request: \(error)")
            } else if let data = data, let response = response as? HTTPURLResponse {
                print("statuscode: \(response.statusCode) data: \(data)")
                do {
                    let result = try JSONDecoder().decode(NewsModel.self, from: data)
                    completion(result.articles)
                } catch {
                    print("Failed connect to \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
