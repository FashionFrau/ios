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

    @IBOutlet weak var gradientView: UIView!

    @IBOutlet weak var lookImage: UIImageView!

    @IBOutlet weak var profileImage: RoundImageView!

    @IBOutlet weak var nameLabel: UILabel!

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */

    override func awakeFromNib() {
        super.awakeFromNib()

        gradientEffect()

        profileImage.af_cancelImageRequest()
        profileImage.layer.removeAllAnimations()
        profileImage.image = nil

        lookImage.af_cancelImageRequest()
        lookImage.layer.removeAllAnimations()
        lookImage.image = nil
    }


    func update(look: LookCard) {

        nameLabel.text = look.profileName

        profileImage.af_setImage(withURL: look.profileUrl)

        lookImage.af_setImage(withURL: look.lookUrl)
    }

    private func gradientEffect() {
        let gradient = CAGradientLayer()

        gradient.frame = gradientView.bounds
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x:0.5, y:0.5)


        gradient.colors = [UIColor.black.withAlphaComponent(0.0).cgColor, UIColor.black.withAlphaComponent(0.1).cgColor]

        gradient.locations = [NSNumber(value: 0.0), NSNumber(value: 1.0)]

        gradientView.layer.addSublayer(gradient)
    }

}
