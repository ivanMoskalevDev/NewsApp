//
//  NewsCell.swift
//  NewsApp
//
//  Created by Иван Москалев on 25.07.2023.
//

import UIKit
import SnapKit

protocol NewsCellDelegateProtocol: AnyObject {
    var  viewModel: HomeViewModel { get set }
    func didTapCell(model: Article?)
    func didTapFavorite(isChecked: Bool)
}

extension NewsCellDelegateProtocol {
    func didTapCell(model: Article?){}
    func didTapFavorite(isChecked: Bool) {}
}

class NewsCell: UITableViewCell {
    
    weak var delegate: NewsCellDelegateProtocol?
    private var idCell: Int?
    //private var model: NewsCellModel?
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical //задаем положение по вертикали
        stack.spacing = 16 //расстояние между элементами
        stack.layer.cornerRadius = 16
        stack.backgroundColor = UIColor(named: "CardColor")
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.contentMode = .scaleAspectFit
        return stack
    }()
    
    private let stackTop: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.backgroundColor = .none
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.textAlignment = .left
        title.numberOfLines = 4
        title.textColor = UIColor(named: "CardTextColor")
        return title
    }()
    
    private let cellImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        return iv
    }()
    
    private let dateLabel: UILabel = {
        let date = UILabel()
        date.textAlignment = .right
        date.font = UIFont(name: date.font.familyName, size: 12)
        date.textColor = UIColor(named: "CardTopTextColor")
        return date
    }()
    
    private let authorLabel: UILabel = {
        let author = UILabel()
        author.textAlignment = .left
        author.textColor = .gray
        author.font = UIFont(name: author.font.familyName, size: 18)
        author.numberOfLines = 0
        author.textColor = UIColor(named: "CardTopTextColor")
        return author
    }()
    
    private let buttonFavorite: RadioButton = {
        let btn = RadioButton(frame: .init(origin: .zero, size: CGSize(width: 15, height: 15)),
                              uncheckedImage: UIImage(systemName: "star") ?? UIImage(),
                              checkedImage: UIImage(systemName: "star.fill") ?? UIImage())
        btn.tintColor = .systemYellow
        return btn
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .none  //цвет ячейки
        selectionStyle = .none
        
        //контент внутри ячейки (в данном случае uistackview)
        contentView.layer.shadowColor = .init(red: 0, green: 0, blue: 0, alpha: 150)
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOpacity = 0.1
        
        //обработка нажатия на ячейку
        let tap = UITapGestureRecognizer(target: self, action: #selector(tabHandler))
        contentView.addGestureRecognizer(tap)
        contentView.isUserInteractionEnabled = true
        
        buttonFavorite.addTarget(self, action: #selector(tabFavorite), for: .touchUpInside)

        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func prepareForReuse() {
//        //вызывается когда коллекция готовит ячейку к переиспользованию
//        super.prepareForReuse()
//    }
    
    private func setupConstraints() {
        
        stackTop.addArrangedSubview(authorLabel)
        stackTop.addArrangedSubview(buttonFavorite)
        
        stackView.addArrangedSubview(stackTop)
        stackView.addArrangedSubview(cellImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dateLabel)
        contentView.addSubview(stackView)
        
        buttonFavorite.snp.makeConstraints { make in
            make.width.equalTo(25) //чтобы не сжималась кнопка
        }
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview().inset(12)
        }
    }
    
    func updateCell(with model: NewsCellModel, id: Int) {
        idCell = id
        buttonFavorite.isChecked = model.isFavorite
        authorLabel.text = model.newsModel.author
        titleLabel.text = model.newsModel.title
        dateLabel.text = model.newsModel.publishedAt?.replacingOccurrences(of: "T", with: " ")
                                                        .replacingOccurrences(of: "Z", with: " ")
    }
    
    @objc private func tabHandler() {
        guard let id = idCell else {return}
        delegate?.didTapCell(model: self.delegate?.viewModel.newsCellModel[id].newsModel)
    }
    
    @objc private func tabFavorite() {
        guard let id = idCell else {return}
        self.delegate?.viewModel.newsCellModel[id].isFavorite = buttonFavorite.isChecked
        delegate?.didTapFavorite(isChecked: buttonFavorite.isChecked)
    }
}
