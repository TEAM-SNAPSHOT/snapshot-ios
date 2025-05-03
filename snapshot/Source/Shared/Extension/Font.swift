//
//  PretendardWeight.swift
//  snapshot
//
//  Created by cher1shRXD on 5/3/25.
//


import SwiftUI

enum PrimaryFont: String {
    case regular = "Coiny-Regular"
}

extension Font {
    private static func primaryFont(weight: PrimaryFont, size: CGFloat) -> Self {
        Font.custom(weight.rawValue, size: size)
    }
    
    static func primary(_ size: CGFloat) -> Self {
        Font.primaryFont(weight: .regular, size: size)
    }
}
