//
//  CoinDetailResponse.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/20.
//

import Foundation

struct CoinDetailResponse: Codable {
    let status: String
    let data: CoinDetailData
}

struct CoinDetailData: Codable {
    let coin: CoinDetailInfo
}

struct CoinDetailInfo: Codable {
    let uuid: String
    let symbol: String
    let name: String
    let description: String?
    let iconUrl: String
    let websiteUrl: String?
    let price: String
    let change: String
    let marketCap: String
    let volume24h: String?
    let supply: Supply
    let sparkline: [String?]
    let allTimeHigh: AllTimeHigh
    
    enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, description, iconUrl, websiteUrl, price, change, marketCap
        case volume24h = "24hVolume"
        case supply, sparkline, allTimeHigh
    }
}

struct Supply: Codable {
    let circulating: String
    let total: String
    let max: String?
}

struct AllTimeHigh: Codable {
    let price: String
    let timestamp: Int
}
