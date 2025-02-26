//
//  CoinTableViewCell.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/21.
//

import Foundation
import UIKit
import SwiftUI

class CoinTableViewCell: UITableViewCell {
    private var hostingController: UIHostingController<CoinCellContent>?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hostingController?.view.removeFromSuperview()
        hostingController = nil
    }
    
    func configure(with coin: Coin) {
        let content = CoinCellContent(coin: coin)
        if hostingController == nil {
            hostingController = UIHostingController(rootView: content)
            hostingController?.view.backgroundColor = .clear
            
            if let hostingView = hostingController?.view {
                hostingView.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(hostingView)
                
                NSLayoutConstraint.activate([
                    hostingView.topAnchor.constraint(equalTo: contentView.topAnchor),
                    hostingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    hostingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    hostingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
                ])
            }
        } else {
            hostingController?.rootView = content
        }
    }
}
