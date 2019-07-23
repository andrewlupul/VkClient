//
//  Font.swift
//  VkClient
//
//  Created by andrewlupul on 24/07/2019.
//  Copyright © 2019 lupuls. All rights reserved.
//

import UIKit


enum FontWeight {
    case light
    case regular
    case bold
}


struct FontSize {
    let value: CGFloat
    
    /// 10
    static let xxSmall: FontSize = 10
    /// 12
    static let xSmall: FontSize = 12
    /// 14
    static let small: FontSize = 14
    /// 16
    static let medium: FontSize = 16
    /// 18
    static let large: FontSize = 18
    /// 20
    static let xLarge: FontSize = 20
    /// 22
    static let xxLarge: FontSize = 22
    /// 24
    static let xxxLarge: FontSize = 24
}


extension FontSize: ExpressibleByFloatLiteral {
    init(floatLiteral: Float) {
        self.value = CGFloat(floatLiteral)
    }
}


extension FontSize: ExpressibleByIntegerLiteral {
    init(integerLiteral: Int) {
        self.value = CGFloat(integerLiteral)
    }
}


extension UIFont {
    static func primaryFont(ofSize: FontSize, weight: FontWeight = .regular) -> UIFont {
        let fontName: String!
        
        switch weight {
        case .light:
            fontName = "Helvetica-Light"
        case .regular:
            fontName = "Helvetica"
        case .bold:
            fontName = "Helvetica-Bold"
        }
        
        return UIFont(name: fontName, size: ofSize.value) ?? UIFont.systemFont(ofSize: ofSize.value)
    }
}
