//
//  CoinDetailView.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/21.
//

import Foundation
import SwiftUI

struct CoinDetailView: View {
    @StateObject private var viewModel: CoinDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(coin: Coin) {
        _viewModel = StateObject(wrappedValue: CoinDetailViewModel(coinId: coin.uuid))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                switch viewModel.loadingState {
                case .loading:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .loaded:
                    headerView
                    if let coinDetail = viewModel.coinDetail {
                        priceSection(coinDetail)
                        chartSection(coinDetail)
                        statisticsSection(coinDetail)
                        descriptionSection(coinDetail)
                    }
                    
                case .error(let string):
                    Text(string)
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task { await viewModel.loadCoinDetail() }
        }
    }
    
    private var headerView: some View {
        HStack(spacing: 12) {
            if let coinDetail = viewModel.coinDetail {
                LoadImage(url: coinDetail.iconUrl)
                .frame(width: 50, height: 50)
                
                VStack(alignment: .leading) {
                    Text(coinDetail.name)
                        .font(.wfuturaMedium(size: 18))
                    Text(coinDetail.symbol)
                        .font(.openSansMedium(size: 14))
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
        }
    }
    
    private func priceSection(_ coinDetail: CoinDetailInfo) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(verbatim: .localized(.currentPriceTitle))
                .font(.wfuturaSemiBold(size: 16))
            
            HStack {
                Text("$\(String(format: "%.2f", Double(coinDetail.price) ?? 0))")
                    .font(.wfuturaMedium(size: 14))
                
                Text("\(coinDetail.change)%")
                    .font(.openSansMedium(size: 14))
                    .foregroundColor(Double(coinDetail.change) ?? 0 >= 0 ? .green : .red)
            }
        }
    }
    
    private func chartSection(_ coinDetail: CoinDetailInfo) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(verbatim: .localized(.priceChartTitle))
                .font(.wfuturaMedium(size: 16))
            
            Picker("Timeframe", selection: $viewModel.selectedTimeframe) {
                ForEach(CoinDetailViewModel.Timeframe.allCases, id: \.self) { timeframe in
                    Text(timeframe.rawValue)
                        .font(.openSansMedium(size: 14))
                        .tag(timeframe)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            // Convert sparkline data to chart data
            let sparkline: [String] = coinDetail.sparkline.compactMap { $0 }
            if let sparklineData = convertSparklineToChartData(sparkline) {
                ChartView(data: sparklineData, strokeColor: Double(coinDetail.change) ?? 0 >= 0 ? .green : .red)
                    .frame(height: 200)
                    .background(Color(red: 0.95, green: 0.95, blue: 0.95))
            }
        }
        .onReceive(viewModel.$selectedTimeframe) { timeframe in
            Task { await viewModel.loadCoinDetail() }
        }
    }
    
    private func statisticsSection(_ coinDetail: CoinDetailInfo) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(verbatim: .localized(.statisticsTitle))
                .font(.wfuturaMedium(size: 16))
            
            StatCard(title: .localized(.marketCapTitle), value: "$\(formatLargeNumber(Double(coinDetail.marketCap) ?? 0))")
            StatCard(title: .localized(.volume24hTitle), value: "$\(formatLargeNumber(Double(coinDetail.volume24h ?? "0") ?? 0))")
            StatCard(title: .localized(.circulatingSupplyTitle), value: formatLargeNumber(Double(coinDetail.supply.circulating) ?? 0))
            if let maxSupply = coinDetail.supply.max {
                StatCard(title: .localized(.maxSupplyTitle), value: formatLargeNumber(Double(maxSupply) ?? 0))
            }
            StatCard(title: .localized(.allTimeHighTitle), value: "$\(String(format: "%.2f", Double(coinDetail.allTimeHigh.price) ?? 0))")
        }
    }
    
    private func descriptionSection(_ coinDetail: CoinDetailInfo) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(verbatim: .localized(.aboutTitle))
                .font(.wfuturaMedium(size: 16))
            
            if let description = coinDetail.description {
                Text(description)
                    .font(.openSansRegular(size: 14))
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func convertSparklineToChartData(_ sparkline: [String]) -> [Double]? {
        return sparkline.compactMap { Double($0) }
    }
    
    private func formatLargeNumber(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        if number >= 1_000_000_000_000 {
            return "\(formatter.string(from: NSNumber(value: number / 1_000_000_000_000)) ?? "")T"
        } else if number >= 1_000_000_000 {
            return "\(formatter.string(from: NSNumber(value: number / 1_000_000_000)) ?? "")B"
        } else if number >= 1_000_000 {
            return "\(formatter.string(from: NSNumber(value: number / 1_000_000)) ?? "")M"
        }
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
}

// MARK: - Supporting Views
struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.wfuturaMedium(size: 16))
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.openSansSemiBold(size: 16))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct ChartView: View {
    let data: [Double]
    let strokeColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let xStep = geometry.size.width / CGFloat(data.count - 1)
                let yScale = geometry.size.height / (data.max()! - data.min()!)
                
                path.move(to: CGPoint(x: 0, y: geometry.size.height - (data[0] - data.min()!) * yScale))
                
                for i in 1..<data.count {
                    let x = xStep * CGFloat(i)
                    let y = geometry.size.height - (data[i] - data.min()!) * yScale
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(strokeColor, lineWidth: 2)
        }
    }
}
