//
//  MockCoinListView.swift
//  CoinRankTests
//
//  Created by Ntobeko Sikithi on 2025/02/25.
//

import Foundation
@testable import CoinRank

class MockCoinListView: CoinListView {
    var showLoadingIndicatorCallCount = 0
    var hideLoadingIndicatorCallCount = 0
    var refreshTableViewCallCount = 0
    var displayErrorCallCount = 0
    var lastErrorMessage: String?
    
    func showLoadingIndicator() {
        showLoadingIndicatorCallCount += 1
    }
    
    func hideLoadingIndicator() {
        hideLoadingIndicatorCallCount += 1
    }
    
    func refreshTableView() {
        refreshTableViewCallCount += 1
    }
    
    func displayError(message: String) {
        displayErrorCallCount += 1
        lastErrorMessage = message
    }
}
