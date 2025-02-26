//
//  Font+Extension.swift
//  CoinRank
//
//  Created by Ntobeko Sikithi on 2025/02/25.
//

import Foundation
import SwiftUI

extension Font {
    static func wfuturaSemiBold(size: CGFloat) -> Font {
        return Font.custom("WFutura-SemiBold", size: size)
    }
    
    static func openSansSemiBold(size: CGFloat) -> Font {
        return Font.custom("OpenSans-SemiBold", size: size)
    }
    
    static func wfuturaMedium(size: CGFloat) -> Font {
        return Font.custom("WFutura-Medium", size: size)
    }
    
    static func openSansMedium(size: CGFloat) -> Font {
        return Font.custom("OpenSans-Medium", size: size)
    }
    
    static func openSansRegular(size: CGFloat) -> Font {
        return Font.custom("OpenSans-Regular", size: size)
    }
    
    static func openSansLight(size: CGFloat) -> Font {
        return Font.custom("OpenSans-Light", size: size)
    }
}
