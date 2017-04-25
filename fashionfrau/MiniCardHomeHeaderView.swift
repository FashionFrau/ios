//
//  MiniCardHomeHeaderView.swift
//  fashionfrau
//
//  Created by Nilson Junior on 23.04.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit

class MiniCardHomeHeaderView: UICollectionReusableView {

    @IBOutlet weak var profileImage: RoundImageView!

    @IBOutlet weak var backgrounRecentLikedView: UIView! {
        didSet{
            self.backgrounRecentLikedView.layer.borderColor = UIColor.white.cgColor
            self.backgrounRecentLikedView.layer.borderWidth = 1
        }
    }

    override func prepareForReuse() {

        super.prepareForReuse()

        profileImage.af_cancelImageRequest()
        profileImage.layer.removeAllAnimations()
        profileImage.image = nil
    }

}
