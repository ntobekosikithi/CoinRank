//
//  CoinCellContent.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/21.
//

import Foundation
import SwiftUI

struct CoinCellContent: View {
    let coin: Coin
    
    var body: some View {
        HStack(spacing: 12) {
            LoadImage(url: coin.iconUrl)
            .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(coin.name)
                    .font(.wfuturaMedium(size: 18))
                Text(coin.symbol)
                    .font(.openSansRegular(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(String(format: "%.2f", Double(coin.price) ?? 0))")
                    .font(.wfuturaMedium(size: 16))
                
                Text("\(coin.change)%")
                    .font(.openSansRegular(size: 14))
                    .foregroundColor(Double(coin.change) ?? 0 >= 0 ? .green : .red)
            }
        }
        .padding(.vertical, 8)
    }
}
