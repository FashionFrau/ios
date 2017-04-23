//
//  MiniCardFavoriteCell.swift
//  fashionfrau
//
//  Created by Nilson Junior on 15/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import Device

class MiniCardFavoriteCell: UICollectionViewCell {

    @IBOutlet weak var lookImage: UIImageView!

    @IBOutlet weak var profileImage: RoundImageView!

    @IBOutlet weak var profileNameLabel: UILabel!

    @IBOutlet weak var likesLabel: UILabel!

    @IBOutlet weak var hashtagLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        shadowEffect()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        lookImage.af_cancelImageRequest()
        lookImage.layer.removeAllAnimations()
        lookImage.image = nil

        profileImage.af_cancelImageRequest()
        profileImage.layer.removeAllAnimations()
        profileImage.image = nil
    }


    func shadowEffect() {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 10
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
    }
}
