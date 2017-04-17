//
//  CardCollectionViewCell.swift
//  fashionfrau
//
//  Created by Nilson Junior on 15/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit

class MiniCardViewCell: UICollectionViewCell {

    @IBOutlet weak var lookImage: UIImageView!

    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var profileNameLabel: UILabel!

    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var hashtagLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.layer.masksToBounds = true

        shadowEffect()
    }


    func shadowEffect() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 4
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
    }
}
