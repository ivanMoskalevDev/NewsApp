//
//  CoordinatorApp.swift
//  NewsApp
//
//  Created by Иван Москалев on 25.07.2023.
//

import UIKit

protocol CoordinatorAppProtocol {
    var navigationController: UINavigationController {get set}
    func start()
}

class CoordinatorApp: CoordinatorAppProtocol {
        
    var navigationController: UINavigationController
    
    var homeViewModel: HomeViewModel = HomeViewModel()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController  
    }
    
    func start() {
        let hvc = HomeViewController(viewModel: homeViewModel, coordinator: self)
        navigationController.pushViewController(hvc, animated: true)
    }
    
}
