//
//  FavoritesViewController.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/24.
//

import Foundation
import UIKit
import SwiftUI

class FavoritesViewController: UIViewController {
    
    private let tableView = UITableView()
    private lazy var viewModel: FavoritesViewModel = {
        return FavoritesViewModel(view: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavorites()
    }
    
    private func setupUI() {
        title = .localized(.favoritesScreenTitle)
        view.backgroundColor = .systemBackground
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(CoinTableViewCell.self, forCellReuseIdentifier: "CoinCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

// MARK: - CoinListView functions
extension FavoritesViewController: CoinListView {
    func showLoadingIndicator() {
        self.showActivityIndicatory()
    }
    
    func hideLoadingIndicator() {
        self.hideActivityIndicatory()
    }
    
    func refreshTableView() {
        tableView.reloadData()
    }
    
    func displayError(message: String) {
        self.showPopup(message: message) { [weak self] in
            self?.viewModel.loadFavorites()
        }
    }
}

// MARK: - UITableView Extension for Favorites
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoriteCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell", for: indexPath) as? CoinTableViewCell else {
            return UITableViewCell()
        }
        let coin = viewModel.favoriteCoins[indexPath.row]
        cell.configure(with: coin)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = viewModel.favoriteCoins[indexPath.row]
        let detailView = CoinDetailView(coin: coin)
        let hostingController = UIHostingController(rootView: detailView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {
        let coin = viewModel.favoriteCoins[indexPath.row]
        
            let action = UIContextualAction(style: .destructive, title: .localized(.removeTitle)) { [weak self] _, _, completion in
            self?.viewModel.removeFavorite(coin)
            self?.viewModel.loadFavorites()
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}
