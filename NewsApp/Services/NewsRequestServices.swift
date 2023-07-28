//
//  NewsRequestServices.swift
//  NewsApp
//
//  Created by Иван Москалев on 25.07.2023.
//

import Foundation

class NewsRequestServices {
    
    let ApiKey = "eb68bf7b53034f73b43599e1d339bd46"
    
    func getNews(category: TagCategory, completion: @escaping ([Article]) -> Void) {
        var strURL = "url"
       
        switch category {
        case .all:
            strURL = "https://newsapi.org/v2/top-headlines?country=ru&apiKey=\(ApiKey)"
        default:
            strURL = "https://newsapi.org/v2/top-headlines?country=ru&category=\(category)&apiKey=\(ApiKey)"
        }
        
        guard let url = URL(string: strURL) else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            //response - статус или ошибка
            //error - ошибка детальнее
            if error != nil {

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
}
