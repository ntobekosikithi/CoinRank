//
//  CoinDetailsRepository.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/20.
//

import Foundation
protocol CoinDetailsRepository {
    func fetchCoinDetails(uuid: String, timePeriod: String) async throws -> CoinDetailResponse
}

class CoinDetailsRepositoryImplementation: CoinDetailsRepository {
    
    @Inject private var service: CoinService
    
    func fetchCoinDetails(uuid: String, timePeriod: String) async throws -> CoinDetailResponse {
        let endpoint = "\(Constants.Endpoint.coinDetails)\(uuid)?timePeriod=\(timePeriod)"
        
        let coinDetailResponse: CoinDetailResponse = try await service.Get(url: endpoint)
        return coinDetailResponse
    }
    
}
