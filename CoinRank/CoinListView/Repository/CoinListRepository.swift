//
//  CoinListRepository.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/20.
//

import Foundation
protocol CoinListRepository {
    func fetchCoins(currentPage: Int) async throws -> CoinListResponse
}

class CoinListRepositoryImplementation: CoinListRepository {
    
    @Inject private var service: CoinService
    
    func fetchCoins(currentPage: Int) async throws -> CoinListResponse {
        let offset = currentPage * Constants.pageSize
        let endpoint = "\(Constants.Endpoint.coinList)?offset=\(offset)&limit=\(Constants.pageSize)"
        
        let coinListResponse: CoinListResponse = try await service.Get(url: endpoint)
        return coinListResponse
    }
}
