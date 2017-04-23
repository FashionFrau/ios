//
//  RoundImageView.swift
//  fashionfrau
//
//  Created by Nilson Junior on 22.04.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = frame.size.height / 2
        layer.masksToBounds = true
    }

}
