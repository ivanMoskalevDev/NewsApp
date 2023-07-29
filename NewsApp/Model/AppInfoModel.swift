//
//  AppInfoModel.swift
//  NewsApp
//
//  Created by Иван Москалев on 28.07.2023.
//

import UIKit

enum AppTheme: Int {
    case system
    case light
    case dark
    
    func getUserInterfaceStyle() -> UIUserInterfaceStyle {
        switch self {
        case .system:
            return UIUserInterfaceStyle.unspecified
        case .light:
            return UIUserInterfaceStyle.light
        case .dark:
            return UIUserInterfaceStyle.dark
        }
    }
}

struct AppInfoModel {
    var theme: AppTheme
}
