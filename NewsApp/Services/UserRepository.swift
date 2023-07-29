//
//  UserRepository.swift
//  NewsApp
//
//  Created by Иван Москалев on 30.07.2023.
//


import UIKit

protocol EnumTypeProtocol {
    func make() -> String
}

protocol TypeModelProtocol {
    associatedtype TypeModel
    func storeInfo(model: TypeModel)
    func getInfo() -> (TypeModel?)
}

enum Key: String, CaseIterable, EnumTypeProtocol {

    case theme
    
    func make() -> String {
        return self.rawValue
    }
}

class UserRepository<TypeModel>: TypeModelProtocol {

    var model: TypeModel?
    
    let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func storeInfo(model: TypeModel) {
        if let castModel = model as? AppInfoModel {
            saveValue(forKey: Key.theme, value: castModel.theme.rawValue)
        }
    }
    
    func getInfo() -> (TypeModel?) {
        
        //if TypeModel.self is AppInfoModel.Type {}
        
        if var castModel = model as? AppInfoModel {
            // TODO: FixMe
            guard let theme: Int? = readValue(forKey: Key.theme), theme != nil else { return nil }
            castModel.theme = AppTheme(rawValue: theme!) ?? .system

            model = castModel as? TypeModel
        }
        return model
    }
    
    func removeInfo() {
        if self.model is AppInfoModel {
            Key.allCases.map{$0.make()}.forEach { key in
                userDefaults.removeObject(forKey: key)
            }
        }
    }
    
    private func saveValue(forKey key: EnumTypeProtocol, value: Any) {
        userDefaults.set(value, forKey: key.make())
    }
    
    private func readValue<T>(forKey key: EnumTypeProtocol) -> T? {
        return userDefaults.value(forKey: key.make()) as? T
    }
}
