//
//  MockCoinDetailsRepository.swift
//  CoinRankTests
//
//  Created by Ntobeko Sikithi on 2025/02/25.
//

import Foundation
@testable import CoinRank

class MockCoinDetailsRepository: CoinDetailsRepository {
    var mockResponse: CoinDetailResponse?
    var mockError: Error?
    var fetchCoinDetailsCallCount = 0
    
    func fetchCoinDetails(uuid: String, timePeriod: String) async throws -> CoinDetailResponse {
        fetchCoinDetailsCallCount += 1
        
        if let error = mockError {
            throw error
        }
        return mockResponse ?? MockCoinDetailsRepository.createMockCoinDetailResponse()
    }
    
    static func createMockCoinDetailResponse() -> CoinDetailResponse {
        return CoinDetailResponse(
            status: "success",
            data: CoinDetailData(
                coin: createMockCoinDetail()
            )
        )
    }
    
    static func createMockCoinDetail() -> CoinDetailInfo {
        return CoinDetailInfo(
            uuid: "1",
            symbol: "BTC",
            name: "Bitcoin",
            description: "A decentralized digital currency.",
            iconUrl: "https://example.com/bitcoin.png",
            websiteUrl: "https://bitcoin.org",
            price: "50000",
            change: "2.5",
            marketCap: "1T",
            volume24h: "10B",
            supply: Supply(
                circulating: "19000000",
                total: "21000000",
                max: "21000000"
            ),
            sparkline: ["50000", "50200", "49900"],
            allTimeHigh: AllTimeHigh(
                price: "69000",
                timestamp: 1637193600
            )
        )
    }
}
