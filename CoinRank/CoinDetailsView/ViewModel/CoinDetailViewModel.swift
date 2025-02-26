//
//  CoinDetailViewModel.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/21.
//

import Foundation

class CoinDetailViewModel: ObservableObject {
    @Published var coinDetailResponse: CoinDetailResponse?
    @Published var coinDetail: CoinDetailInfo?
    @Published var selectedTimeframe: Timeframe = .day
    @Published private(set) var loadingState: LoadingState = .loading
    
    @Inject private var repository: CoinDetailsRepository
    private let coinId: String
    
    enum Timeframe: String, CaseIterable {
        case day = "24h"
        case week = "7d"
        case month = "30d"
        case year = "1y"
    }
    
    init(coinId: String) {
        self.coinId = coinId
    }
    
    @MainActor
    func loadCoinDetail() async {
        do {
            coinDetailResponse = try await repository.fetchCoinDetails(uuid: coinId, timePeriod: selectedTimeframe.rawValue)
            coinDetail = coinDetailResponse?.data.coin
            loadingState = .loaded
        } catch {
            loadingState = .error(error.localizedDescription)
        }
    }
}
