//
//  CoinService.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/20.
//

import Foundation

protocol CoinService {
    func Get<T: Decodable>(url: String) async throws -> T
}
