//
//  CoinListViewModel.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/21.
//

import Foundation

class CoinListViewModel: ObservableObject {
    @Published var coinListResponse: CoinListResponse!
    @Published var coins: [Coin] = []
    @Published var currentPage = 0
    
    private weak var view: CoinListView?
    @Inject private var repository: CoinListRepository
    @Inject private var favoritesManager: FavoritesManager
    private var isLoadingMoreCoins = false
    
    init(view: CoinListView) {
        self.view = view
    }
    
    @MainActor
    func fetchCoinList() async {
        guard !isLoadingMoreCoins, coins.count < 100 else { return }
        isLoadingMoreCoins = true
        self.view?.showLoadingIndicator()
        do {
            coinListResponse = try await repository.fetchCoins(currentPage: self.currentPage)
            coins.append(contentsOf: coinListResponse.data.coins)
            self.currentPage += 1
            self.view?.hideLoadingIndicator()
            self.view?.refreshTableView()
            
        } catch {
            self.view?.hideLoadingIndicator()
            self.view?.displayError(message: error.localizedDescription)
        }
        isLoadingMoreCoins = false
    }
    
    func sortByPrice() {
        coins.sort { Double($0.price) ?? 0 > Double($1.price) ?? 0 }
    }
    
    func sortByPerformance() {
        coins.sort { Double($0.change) ?? 0 > Double($1.change) ?? 0 }
    }
    
    func sortByRanking() {
        coins.sort { $0.rank < $1.rank }
    }
    
    func removeFavorite(_ coin: Coin) {
        favoritesManager.removeFavorite(coin)
    }
    
    func saveFavorite(_ coin: Coin) {
        favoritesManager.saveFavorite(coin)
    }
    
    func isCoinFavorite(_ coin: Coin) -> Bool {
        return favoritesManager.isFavorite(coin)
    }
}
