//
//  Card.swift
//  fashionfrau
//
//  Created by Nilson Junior on 10/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import AlamofireImage

class CardView: UIView {

    @IBOutlet weak var lookImage: UIImageView!

    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */

    func update(look: Look) {

        nameLabel.text = look.profileName

        profileImage.af_setImage(withURL: look.profileUrl)

        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: lookImage.frame.size,
            radius: 20.0
        )

        lookImage.af_setImage(withURL: look.lookUrl, filter: filter, runImageTransitionIfCached: true)
    }

}
