//
//  SetupTextField.swift
//  NewsApp
//
//  Created by Иван Москалев on 29.07.2023.
//

import UIKit

extension UISearchTextField {
    
    func addToolBarOnKeyboard(parent: AnyObject, action: Selector? = nil) {
        
        var keyboardToolbar: UIToolbar
        if parent is UIViewController {
            keyboardToolbar =  UIToolbar(frame: CGRect(x: 0, y: 0, width: parent.view.frame.size.width, height: 44))
        } else if parent is UIView {
            keyboardToolbar =  UIToolbar(frame: CGRect(x: 0, y: 0, width: parent.frame.size.width, height: 44))
        } else {
            return
        }
        
        //let keyboardToolbar =  UIToolbar(frame: CGRect(x: 0, y: 0, width: parent.frame.size.width, height: 44))
        keyboardToolbar.layer.opacity = 2
        keyboardToolbar.layer.shadowOpacity = 0.2
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: parent, action: action)
        let hideButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(resignFirstResponder))
        
        keyboardToolbar.items = [hideButton,flexibleSpace,searchButton]
        
        keyboardToolbar.sizeToFit()
        self.inputAccessoryView = keyboardToolbar
        
    }
}
