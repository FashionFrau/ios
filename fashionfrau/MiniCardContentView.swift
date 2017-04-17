//
//  MiniCardContentView.swift
//  fashionfrau
//
//  Created by Nilson Junior on 17/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit

@IBDesignable
class MiniCardContentView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }

}
