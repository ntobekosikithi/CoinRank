//
//  MockFavoritesManager.swift
//  CoinRankTests
//
//  Created by Ntobeko Sikithi on 2025/02/25.
//

import Foundation
@testable import CoinRank

class MockFavoritesManager: FavoritesManager {
    private var favoriteCoins: [Coin] = []
    
    func saveFavorite(_ coin: Coin) {
        if !isFavorite(coin) {
            favoriteCoins.append(coin)
        }
    }
    
    func removeFavorite(_ coin: Coin) {
        favoriteCoins.removeAll { $0.uuid == coin.uuid }
    }
    
    func getFavorites() -> [Coin] {
        return favoriteCoins
    }
    
    func isFavorite(_ coin: Coin) -> Bool {
        return favoriteCoins.contains { $0.uuid == coin.uuid }
    }
}
