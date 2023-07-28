//
//  RadioButton.swift
//  NewsApp
//
//  Created by Иван Москалев on 28.07.2023.
//

import UIKit

final class RadioButton: UIButton {
      
    private var checkedImage: UIImage?
    private var uncheckedImage: UIImage?
    
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
    
    init(frame: CGRect, uncheckedImage: UIImage, checkedImage: UIImage) {
        super.init(frame: frame)
        
        self.checkedImage = checkedImage
        self.uncheckedImage = uncheckedImage
        
        setImage(
            uncheckedImage.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        
        imageView?.contentMode = .scaleAspectFit
        contentVerticalAlignment = .fill
        contentHorizontalAlignment = .fill
        
        addTarget(self, action: #selector(tap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tap() {
        isChecked = !isChecked
    }
    
}
