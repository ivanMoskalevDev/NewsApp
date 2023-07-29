//
//  AppManager.swift
//  NewsApp
//
//  Created by Иван Москалев on 30.07.2023.
//

import Foundation

class AppManager {
    
    static let shared = AppManager()
    
    private let userRepository = UserRepository<AppInfoModel>()
    var appInfo: AppInfoModel = .init(theme: .light)
    
    let maxSavedFavorites = 50
    
    private init() {

        userRepository.model = appInfo
        
        // считываем информацию приложения из памяти
        guard let ai: AppInfoModel = userRepository.getInfo() else { return }
        appInfo = ai
        
    }
    
    
    func storeTheme(theme: AppTheme) {
        appInfo.theme = theme
        userRepository.storeInfo(model: appInfo)
    }

}
