//
//  CoinListViewController.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/21.
//

import Foundation
import UIKit
import SwiftUI

protocol CoinListView: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func refreshTableView()
    func displayError(message: String)
}

class CoinListViewController: UIViewController {
    private let tableView = UITableView()

    private lazy var filterButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
                                                 style: .plain,
                                                 target: nil,
                                                 action: nil)
    }()
    
    private lazy var viewModel: CoinListViewModel = {
       return CoinListViewModel(view: self)
    }()
    
    private var viewDidAppearCompleted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        Task { await viewModel.fetchCoinList() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppearCompleted = true
    }
    
    private func setupUI() {
        title = .localized(.coinListScreenTitle)
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = filterButton
        
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
    
    private func setupBindings() {
        filterButton.target = self
        filterButton.action = #selector(showFilterOptions)
    }
    
    @objc private func showFilterOptions() {
        let alert = UIAlertController(title: .localized(.sortByTitle), message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: .localized(.highestPriceTitle), style: .default) { [weak self] _ in
            self?.viewModel.sortByPrice()
            self?.tableView.reloadData()
        })
        
        alert.addAction(UIAlertAction(title: .localized(.bestPerformanceTitle), style: .default) { [weak self] _ in
            self?.viewModel.sortByPerformance()
            self?.tableView.reloadData()
        })
        
        alert.addAction(UIAlertAction(title: .localized(.byDefaultTitle), style: .default) { [weak self] _ in
            self?.viewModel.sortByRanking()
            self?.tableView.reloadData()
        })
        
        alert.addAction(UIAlertAction(title: .localized(.cancelTitle), style: .cancel))
        
        present(alert, animated: true)
    }
}

// MARK: - CoinListView functions
extension CoinListViewController: CoinListView {
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
            Task { await self?.viewModel.fetchCoinList() }
        }
    }
}

// MARK: - UITableView Extension
extension CoinListViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell", for: indexPath) as? CoinTableViewCell else {
            return UITableViewCell()
        }
        let coin = viewModel.coins[indexPath.row]
        cell.configure(with: coin)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = viewModel.coins[indexPath.row]
        let detailView = CoinDetailView(coin: coin)
        let hostingController = UIHostingController(rootView: detailView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Only execute if view has fully appeared
        guard viewDidAppearCompleted else { return }
        
        let offsetY = scrollView.contentOffset.y
        let tableViewHeight = tableView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if offsetY > (tableViewHeight - scrollViewHeight - 100) {
            Task { await viewModel.fetchCoinList() }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {
        let coin = viewModel.coins[indexPath.row]
        let isFavorite = viewModel.isCoinFavorite(coin)
        
            let action = UIContextualAction(style: .normal, title: isFavorite ? .localized(.unfavoriteTitle) : .localized(.favoriteTitle)) {
                [weak self] _, _, completion in
            if isFavorite {
                self?.viewModel.removeFavorite(coin)
            } else {
                self?.viewModel.saveFavorite(coin)
            }
            completion(true)
        }
        
        action.backgroundColor = isFavorite ? .systemRed : .systemGreen
        return UISwipeActionsConfiguration(actions: [action])
    }
}
