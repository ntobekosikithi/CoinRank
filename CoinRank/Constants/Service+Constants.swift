//
//  Service+Constants.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/20.
//

import Foundation

extension Constants {
    static let baseUrl = "https://api.coinranking.com/v2"
    static let apiKey = "coinranking21b709d1b7d7a7eeee9393b54956b21f152448113f048fb0"
    static let pageSize = 20
    
    struct Endpoint {
        static let coinList = "/coins"
        static let coinDetails = "/coin/"
    }
}
