//
//  FavoritesViewModel.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/21.
//

import Foundation

class FavoritesViewModel: ObservableObject {
    @Published var favoriteCoins: [Coin] = []
    
    private weak var view: CoinListView?
    @Inject private var favoritesManager: FavoritesManager
    
    init(view: CoinListView) {
        self.view = view
    }
    
    func loadFavorites() {
        view?.showLoadingIndicator()
        favoriteCoins = favoritesManager.getFavorites()
        view?.hideLoadingIndicator()
        view?.refreshTableView()
    }
    
    func removeFavorite(_ coin: Coin) {
        favoritesManager.removeFavorite(coin)
    }
}
