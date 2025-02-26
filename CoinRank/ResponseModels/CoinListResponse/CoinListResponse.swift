//
//  CoinListResponse.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/20.
//

import Foundation

struct CoinListResponse: Codable {
    let status: String
    let data: CoinData
}

struct CoinData: Codable {
    let stats: Stats
    let coins: [Coin]
}

struct Stats: Codable {
    let total: Int
    let totalCoins: Int
    let totalMarkets: Int
    let totalExchanges: Int
    let totalMarketCap: String
    let total24hVolume: String
}

struct Coin: Codable, Identifiable {
    let uuid: String
    let symbol: String
    let name: String
    let color: String?
    let iconUrl: String
    let marketCap: String
    let price: String
    let listedAt: Int
    let change: String
    let rank: Int
    let sparkline: [String?]
    let lowVolume: Bool
    let coinrankingUrl: String
    let volume24h: String?
    let btcPrice: String
    
    var id: String { uuid }
    
    enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, color, iconUrl, marketCap, price, listedAt
        case change, rank, sparkline, lowVolume, coinrankingUrl
        case volume24h = "24hVolume"
        case btcPrice
    }
}
