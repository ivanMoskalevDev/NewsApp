//
//  NewsCell.swift
//  NewsApp
//
//  Created by Иван Москалев on 25.07.2023.
//

import UIKit
import SnapKit

protocol NewsCellDelegateProtocol: AnyObject {
    func didTapCell()
    func didTapFavorite()
}

extension NewsCellDelegateProtocol {
    func didTapFavorite() {}
}

class NewsCell: UITableViewCell {
    
    weak var delegate: NewsCellDelegateProtocol?
    private var model: Article?
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical //задаем положение по вертикали
        stack.spacing = 16 //расстояние между элементами
        stack.layer.cornerRadius = 16
        stack.backgroundColor = .white
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    private let stackTop: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.backgroundColor = .none
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.textAlignment = .left
        title.numberOfLines = 4
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
        date.textColor = .gray
        date.font = UIFont(name: date.font.familyName, size: 12)
        return date
    }()
    
    private let authorLabel: UILabel = {
        let author = UILabel()
        author.textAlignment = .left
        author.textColor = .gray
        author.font = UIFont(name: author.font.familyName, size: 18)
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
    
    private func setupConstraints() {
        
        stackTop.addArrangedSubview(authorLabel)
        stackTop.addArrangedSubview(buttonFavorite)
        
        stackView.addArrangedSubview(stackTop)
        stackView.addArrangedSubview(cellImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dateLabel)
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview().inset(12)
        }
    }
    
    func updateCell(with model: Article) {
        //self.model = model
        authorLabel.text = model.author
        titleLabel.text = model.title
        dateLabel.text = model.publishedAt
//        guard let urlStr = self.model?.imageURL else {return}
//        if let url = URL(string: urlStr) {
//            let task = URLSession.shared.dataTask(with: url) { data, response, error in
//                guard let data = data, error == nil else { return }
//                DispatchQueue.main.async { // execute on main thread
//                    self.cellImageView.image = UIImage(data: data)
//                }
//            }
//            task.resume()
//        }
    }
    
    @objc private func tabHandler() {
        delegate?.didTapCell()
    }
    
    @objc private func tabFavorite() {
        delegate?.didTapFavorite()
    }
}
