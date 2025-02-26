//
//  CoinDetailViewModelTests.swift
//  CoinRankTests
//
//  Created by Ntobeko Sikithi on 2025/02/25.
//

import Foundation
import XCTest
@testable import CoinRank

class CoinDetailViewModelTests: XCTestCase {
    private var container: DIContainer = DIContainer.instance
    private var mockRepository: MockCoinDetailsRepository!
    private var serviceUnderTest: CoinDetailViewModel!
    
    override func setUp() {
        super.setUp()
        container = DIContainer.instance
        mockRepository = MockCoinDetailsRepository()
        container.register(CoinDetailsRepository.self) { self.mockRepository }
        
        serviceUnderTest = CoinDetailViewModel(coinId: "mock-id")
    }
    
    override func tearDown() {
        serviceUnderTest = nil
        mockRepository = nil
        container.reset()
        super.tearDown()
    }

    func testLoadCoinDetail_Success() async {
        // Arrange
        let mockResponse = MockCoinDetailsRepository.createMockCoinDetailResponse()
        mockRepository.mockResponse = mockResponse
        
        // Act
        await serviceUnderTest.loadCoinDetail()
        
        // Assert
        XCTAssertEqual(mockRepository.fetchCoinDetailsCallCount, 1)
        XCTAssertNotNil(serviceUnderTest.coinDetailResponse)
        XCTAssertEqual(serviceUnderTest.coinDetail?.uuid, mockResponse.data.coin.uuid)
        XCTAssertEqual(serviceUnderTest.loadingState, .loaded)
    }
    
    func testLoadCoinDetail_Failure() async {
        // Arrange
        mockRepository.mockError = NSError(domain: "TestError", code: 1, userInfo: nil)
        
        // Act
        await serviceUnderTest.loadCoinDetail()
        
        // Assert
        XCTAssertEqual(mockRepository.fetchCoinDetailsCallCount, 1)
        XCTAssertNil(serviceUnderTest.coinDetailResponse)
        XCTAssertNil(serviceUnderTest.coinDetail)
        XCTAssertEqual(serviceUnderTest.loadingState, .error("The operation couldn’t be completed. (TestError error 1.)"))
    }
    
    func testSelectedTimeframe() {
        // Arrange
        let initialTimeframe = serviceUnderTest.selectedTimeframe
        
        // Act
        serviceUnderTest.selectedTimeframe = .week
        
        // Assert
        XCTAssertNotEqual(serviceUnderTest.selectedTimeframe, initialTimeframe)
        XCTAssertEqual(serviceUnderTest.selectedTimeframe, .week)
    }
}
