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
    private var      viewModel:    HomeViewModel
    
    private let carouselView = CarouselView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
        return tableView
    }()
    
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Find news"
        return search
    }()
    
    init(viewModel: HomeViewModel, coordinator: CoordinatorApp?) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
    }
    
    private func bindView() {
        viewModel.bindNewsModel = { model in
            //print("[HVC] model=\(model)")
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
        //buttonScroll.addSubview(testView)
        view.addSubview(carouselView)
        view.addSubview(tableView)
        view.addSubview(searchBar)
        
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
        //AppConstants.shared.storeTheme(theme: TypeTheme(rawValue: themeSegmentedControl.selectedSegmentIndex) ?? .system)
        guard let coordinator = self.coordinator else { return }
        if sender.isChecked {
            coordinator.appInfoModel.theme = .dark
        } else {
            coordinator.appInfoModel.theme = .light
        }
        view.window?.overrideUserInterfaceStyle = coordinator.appInfoModel.theme.getUserInterfaceStyle()
    }

}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell
        else { return UITableViewCell() }
        cell.delegate = self
        cell.updateCell(with: viewModel.news[indexPath.row])
        return cell
    }
    
}

extension HomeViewController: UISearchBarDelegate {
    
}

extension HomeViewController: CarouselViewDelegate {
    func tapCategory(tag: Int) {
        viewModel.getNews(category: TagCategory(rawValue: tag) ?? TagCategory.all)
    }
}

extension HomeViewController: NewsCellDelegateProtocol {
    func didTapCell() {
        print("didTapCell")
    }
}
