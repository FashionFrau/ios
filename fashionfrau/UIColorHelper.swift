//
//  UIColorHelper.swift
//  fashionfrau
//
//  Created by Nilson Junior on 14/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit

extension UIColor {

    static let fashionfrau = UIColor(rgb: 0xFA78A6)
    static let fashionfrauLight = UIColor(rgb: 0xFCF4FB)

    static let fashionfrauWinter = UIColor(rgb: 0x4990E2)
    static let fashionfrauSummer = UIColor(rgb: 0xF2B12D)
    static let fashionfrauFall = UIColor(rgb: 0xB2261C)
    static let fashionfrauSpring = UIColor(rgb: 0x286703)

    static let tabBar = UIColor(rgb: 0xFCF4FB)

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
