//
//  PretendardWeight.swift
//  snapshot
//
//  Created by cher1shRXD on 5/3/25.
//


import SwiftUI

enum PretendardWeight: String {
    case bold = "Pretendard-Bold"
    case semibold = "Pretendard-SemiBold"
    case regular = "Pretendard-Regular"
    case medium = "Pretendard-Medium"
    case light = "Pretendard-Light"
}

extension Font {
    private static func pretendard(weight: PretendardWeight, size: CGFloat) -> Self {
        Font.custom(weight.rawValue, size: size)
    }
    
    static func bold(_ size: CGFloat) -> Self {
        Font.pretendard(weight: .bold, size: size)
    }
    
    static func semibold(_ size: CGFloat) -> Self {
        Font.pretendard(weight: .semibold, size: size)
    }
    
    static func regular(_ size: CGFloat) -> Self {
        Font.pretendard(weight: .regular, size: size)
    }
    
    static func medium(_ size: CGFloat) -> Self {
        Font.pretendard(weight: .medium, size: size)
    }
    
    static func light(_ size: CGFloat) -> Self {
        Font.pretendard(weight: .light, size: size)
    }
}