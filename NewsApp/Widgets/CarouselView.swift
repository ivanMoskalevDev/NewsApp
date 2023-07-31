//
//  CarouselView.swift
//  NewsApp
//
//  Created by Иван Москалев on 26.07.2023.
//

import UIKit
import SnapKit

protocol CarouselViewDelegate: AnyObject {
    func tapCategory(tag: Int)
}

class CarouselView: UIScrollView {
    
    weak var corouselDelegate: CarouselViewDelegate?
    private var categoryButtons: [CarouselButton] = []
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal //задаем положение
        stack.backgroundColor = .clear
        stack.spacing = 8
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "CorouselBackColor")
        showsHorizontalScrollIndicator = false

        categoryButtons.append(CarouselButton(title: "Top", id: TagCategory.all.rawValue))
        categoryButtons.append(CarouselButton(title: "Technology", id: TagCategory.technology.rawValue))
        categoryButtons.append(CarouselButton(title: "Science", id: TagCategory.science.rawValue))
        categoryButtons.append(CarouselButton(title: "Entertainment", id: TagCategory.entertainment.rawValue))
        categoryButtons.append(CarouselButton(title: "Health", id: TagCategory.health.rawValue))
        categoryButtons.append(CarouselButton(title: "Sports", id: TagCategory.sports.rawValue))
        
        for i in 0..<categoryButtons.count {
            categoryButtons[i].addTarget(self, action: #selector(tapButton), for: .touchUpInside)
            stackView.addArrangedSubview(categoryButtons[i])
        }
        
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapButton(sender: CarouselButton!) {
        corouselDelegate?.tapCategory(tag: sender.id)
    }
    
}

class CarouselButton: UIButton {
    let id: Int
    private let title: String
    
    init (title: String, id: Int) {
        self.title = title
        self.id = id
        super.init(frame: .zero)

        setTitle(self.title, for: .normal)

        var configuration = UIButton.Configuration.gray()
        configuration.cornerStyle = .fixed
        configuration.baseForegroundColor = UIColor(named: "TextColor")
        configuration.background.cornerRadius = 8
        configuration.baseBackgroundColor = UIColor(named: "PrimaryColor")
        configuration.buttonSize = .medium
        configuration.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        self.configuration = configuration
        
        //addTarget(.none, action: #selector(tapAnimation), for: .touchUpInside)
  
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowOpacity = 0.1
        //clipsToBounds = true
        //layer.masksToBounds = false
    }
    
    override init(frame: CGRect) {
        self.title = "Button"
        self.id = -1
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
