//
//  MiniCardFavoriteFooterView.swift
//  fashionfrau
//
//  Created by Nilson Junior on 21.04.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit

class MiniCardFavoriteFooterView: UICollectionReusableView {
        
    @IBOutlet weak var dotView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        dotView.layer.cornerRadius = dotView.frame.size.height / 2
        dotView.layer.masksToBounds = true
    }
}
