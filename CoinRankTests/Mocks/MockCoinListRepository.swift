//
//  MockCoinListRepository.swift
//  CoinRankTests
//
//  Created by Ntobeko Sikithi on 2025/02/25.
//

import Foundation
@testable import CoinRank

class MockCoinListRepository: CoinListRepository {
    var mockResponse: CoinListResponse?
    var mockError: Error?
    var fetchCoinsCallCount = 0
    
    func fetchCoins(currentPage: Int) async throws -> CoinListResponse {
        fetchCoinsCallCount += 1
        
        if let error = mockError {
            throw error
        }
        return mockResponse ?? MockCoinListRepository.createMockCoinListResponse()
    }
    
    static func createMockCoinListResponse() -> CoinListResponse {
        return CoinListResponse(
            status: "success",
            data: CoinData(
                stats: Stats(
                    total: 100,
                    totalCoins: 50,
                    totalMarkets: 500,
                    totalExchanges: 100,
                    totalMarketCap: "1T",
                    total24hVolume: "10B"
                ),
                coins: createMockCoins()
            )
        )
    }
    
    static func createMockCoin(
        uuid: String = "1",
        name: String = "Bitcoin",
        symbol: String = "BTC",
        price: String = "50000",
        change: String = "1.3",
        rank: Int = 0
    ) -> Coin {
        return Coin(
            uuid: uuid,
            symbol: symbol,
            name: name,
            color: "#f7931a",
            iconUrl: "https://example.com/bitcoin.png",
            marketCap: "1T",
            price: price,
            listedAt: 1234567890,
            change: change,
            rank: rank,
            sparkline: ["50000", "50200", "49900"],
            lowVolume: false,
            coinrankingUrl: "https://coinranking.com/coin/bitcoin",
            volume24h: "10B",
            btcPrice: "1.0"
        )
    }
    
    static func createMockCoins(count: Int = 3) -> [Coin] {
        return (1...count).map { index in
            createMockCoin(uuid: "\(index)")
        }
    }
}

