//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Иван Москалев on 25.07.2023.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {

    private weak var coordinator:  CoordinatorApp?
    var              viewModel:    HomeViewModel
    
    private let carouselView = CarouselView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
        return tableView
    }()
    
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Find news..."
        return search
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.style = .large
        return activity
    }()
    
    init(viewModel: HomeViewModel, coordinator: CoordinatorApp?) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        searchBar.searchTextField.addToolBarOnKeyboard(parent: self, action: #selector(searchNews))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "AccentColor")
        
        carouselView.corouselDelegate = self
        searchBar.delegate = self
        tableView.dataSource = self
        //tableView.delegate = self
        
        bindView()
        
        setupNavigationBar()
        setupConstrain()
        
        // Запрос топ новостей при запуске
        viewModel.getNews(category: .all)
    }
    
    private func bindView() {
        viewModel.bindNewsModel = { model in
            //print("[HVC] model=\(model)")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        viewModel.bindLoadingNews = { loading in
            DispatchQueue.main.async {
                if loading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "News"
        navigationController?.navigationBar.backgroundColor = UIColor(named: "AccentColor")

        let buttonMoon = RadioButton(frame: .init(origin: .zero, size: CGSize(width: 35, height: 35)),
                                     uncheckedImage: UIImage(systemName: "moon") ?? UIImage(),
                                     checkedImage: UIImage(systemName: "moon.fill") ?? UIImage())
        buttonMoon.tintColor = UIColor(named: "ItemBarColor")
        buttonMoon.isChecked = (AppManager.shared.appInfo.theme == .light) ? false : true
        buttonMoon.addTarget(self, action: #selector(changeAppTheme), for: .touchUpInside)
        
        let buttonFav = UIButton(type: .system)
        buttonFav.frame.size = CGSize(width: 35, height: 35)
        buttonFav.setImage(
            UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        buttonFav.tintColor = UIColor(named: "ItemBarColor")
        buttonFav.imageView?.contentMode = .scaleAspectFit
        buttonFav.contentVerticalAlignment = .fill
        buttonFav.contentHorizontalAlignment = .fill
        buttonFav.isUserInteractionEnabled = false // TODO
        //buttonFav.addTarget(self, action: #selector(self.showWinsAlert), for: .touchUpInside)
        
        let navBarButMoon = UIBarButtonItem(customView: buttonMoon)
        let navBarButFav = UIBarButtonItem(customView: buttonFav)

        navigationItem.rightBarButtonItem = navBarButMoon
        navigationItem.leftBarButtonItem = navBarButFav
        
        let titleHome = UILabel(frame: .init(
            x: 0, y: 0,
            width: view.bounds.width,
            height: view.bounds.height)
        )

        titleHome.textAlignment = .left
        titleHome.text = "News"
        titleHome.textColor = UIColor(named: "ItemBarColor")
        titleHome.font = titleHome.font.withSize(30)
        navigationItem.titleView = titleHome
    }
    
    private func setupConstrain() {
        view.addSubview(carouselView)
        view.addSubview(tableView)
        view.addSubview(searchBar)
        view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
        
        carouselView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(70)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(carouselView.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func changeAppTheme(sender: RadioButton!) {
        let typeTheme: AppTheme = (sender.isChecked) ? .dark : .light
        AppManager.shared.storeTheme(theme: typeTheme)
        view.window?.overrideUserInterfaceStyle = AppManager.shared.appInfo.theme.getUserInterfaceStyle()
    }
    
    @objc private func searchNews() {
        guard let request = searchBar.text else { return }
        viewModel.getSearchNews(with: request)
        searchBar.searchTextField.resignFirstResponder()
    }

}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.newsCellModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell
        else { return UITableViewCell() }
        cell.delegate = self
        cell.updateCell(with: viewModel.newsCellModel[indexPath.row], id: indexPath.row)
        return cell
    }
    
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchNews()
        searchBar.searchTextField.resignFirstResponder()
    }
}

extension HomeViewController: CarouselViewDelegate {
    func tapCategory(tag: Int) {
        viewModel.getNews(category: TagCategory(rawValue: tag) ?? .all)
    }
}

extension HomeViewController: NewsCellDelegateProtocol {
    
    func showInternetAlert(with strUrl: String?) {
        
        let alert = UIAlertController(title: "Safari",
                                      message: "Go to browser?",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            guard let str = strUrl else {return}
            if let link = URL(string: str) {
              UIApplication.shared.open(link)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func didTapCell(model: Article?) {
        showInternetAlert(with: model?.url)
    }
    
    func didTapFavorite(isChecked: Bool) {
        let alert = UIAlertController(title: "Sorry",
                                      message: "Saving to favorites doesn't work yet",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
