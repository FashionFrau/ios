//
//  MiniCardHomeCell.swift
//  fashionfrau
//
//  Created by Nilson Junior on 22.04.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit

class MiniCardHomeCell: UICollectionViewCell {

    var model: MiniLookHome? {
        didSet {
            updateUI()
        }
    }

    @IBOutlet weak var lookImage: UIImageView!

    @IBOutlet weak var profileImage: RoundImageView!

    @IBOutlet weak var profileNameLabel: UILabel!

    @IBOutlet weak var likesLabel: UILabel!

    @IBOutlet weak var seasonLabel: UILabel!

    @IBOutlet weak var seasonBackground: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        profileImage.af_cancelImageRequest()
        profileImage.layer.removeAllAnimations()
        profileImage.image = nil

        lookImage.af_cancelImageRequest()
        lookImage.layer.removeAllAnimations()
        lookImage.image = nil

        seasonLabel.layer.cornerRadius = 5
        seasonLabel.layer.masksToBounds = true

        shadowEffect()
    }
}

extension MiniCardHomeCell {

    fileprivate func updateUI() {
        if let model = self.model {

            lookImage.af_setImage(withURL: model.lookUrl)

            profileImage.af_setImage(withURL: model.profileUrl)

            profileNameLabel.text = model.profileName

            likesLabel.text = "\(model.likes)"

            seasonLabel.text = " \(model.season) "

            seasonBackground.backgroundColor = seasonColor()
        }
    }

    fileprivate func seasonColor() -> UIColor {
        let season = model?.season ?? ""

        switch season {
        case "winter": return UIColor.fashionfrauWinter
        case "summer": return UIColor.fashionfrauSummer
        case "fall": return UIColor.fashionfrauFall
        case "spring": return UIColor.fashionfrauSpring

        default:
            return UIColor.black
        }
    }

    fileprivate func shadowEffect() {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 10
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
    }
}
