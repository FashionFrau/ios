//
//  FFNavigationBar.swift
//  fashionfrau
//
//  Created by Nilson Junior on 14/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit

class FFNavigationBar: UINavigationBar {

    override func awakeFromNib() {
        super.awakeFromNib()

        barTintColor = .fashionfrau

        let courgetteFont = UIFont(name: "Courgette-Regular", size: 25) ??  UIFont.systemFont(ofSize: 25)

        titleTextAttributes = [NSFontAttributeName: courgetteFont, NSForegroundColorAttributeName:UIColor.white]

    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
