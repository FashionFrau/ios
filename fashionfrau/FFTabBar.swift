//
//  FFTabBar.swift
//  fashionfrau
//
//  Created by Nilson Junior on 14/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit

class FFTabBar: UITabBar {

    override func awakeFromNib() {
        super.awakeFromNib()

        tintColor = .fashionfrau
        barTintColor = .tabBar

        layer.borderColor = UIColor.clear.cgColor
        clipsToBounds = true
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
