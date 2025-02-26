//
//  FavoritesManager.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/21.
//

import Foundation

protocol FavoritesManager {
    func saveFavorite(_ coin: Coin)
    func removeFavorite(_ coin: Coin)
    func getFavorites() -> [Coin]
    func isFavorite(_ coin: Coin) -> Bool
}

// MARK: - Favorites Manager Implementation
class FavoritesManagerImplementation: FavoritesManager {
    private let userDefaults: UserDefaults
    private let favoritesKey = "favoriteCoins"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func saveFavorite(_ coin: Coin) {
        var coins = getCoins()
        coins.removeAll { $0.uuid == coin.uuid }
        coins.append(coin)
        saveCoins(coins)
    }
    
    func removeFavorite(_ coin: Coin) {
        var coins = getCoins()
        coins.removeAll { $0.uuid == coin.uuid }
        saveCoins(coins)
    }
    
    func getFavorites()  -> [Coin] {
        return getCoins()
    }
    
    func isFavorite(_ coin: Coin) -> Bool {
        return getCoins().compactMap{ $0.uuid }.contains(coin.uuid)
    }
    
    private func saveCoins(_ coins: [Coin]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(coins) {
            userDefaults.set(encoded, forKey: favoritesKey)
        }
    }
    
    private func getCoins() -> [Coin] {
        let decoder = JSONDecoder()
        if let data = userDefaults.data(forKey: favoritesKey),
           let coins = try? decoder.decode([Coin].self, from: data) {
            return coins
        }
        return []
    }
}
