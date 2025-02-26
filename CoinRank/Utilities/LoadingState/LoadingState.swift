//
//  LoadingState.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/21.
//

import Foundation

enum LoadingState: Equatable {
    case loading
    case loaded
    case error(String)
}
