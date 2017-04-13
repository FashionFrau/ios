//
//  UiTabBar.swift
//  fashionfrau
//
//  Created by Nilson Junior on 12/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit

class FFTabBar: UITabBar {
    override func awakeFromNib() {
        super.awakeFromNib()

        tintColor = UIColor(red: 250/255, green: 120/255, blue: 166/255, alpha: 100)
        backgroundColor = UIColor(red: 253/255, green: 248/255, blue: 253/255, alpha: 100)
    }
}
