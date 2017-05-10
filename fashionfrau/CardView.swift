//
//  Card.swift
//  fashionfrau
//
//  Created by Nilson Junior on 10/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import AlamofireImage
import Flurry_iOS_SDK

class CardView: CornerView {

    fileprivate let cardViewDomainError = "com.fashionfrau.card-view.error"

    fileprivate let placeholderImage = UIImage(named: Images.ProfilePlaceHolder)

    @IBOutlet weak var gradientView: UIView!

    @IBOutlet weak var lookImage: UIImageView!

    @IBOutlet weak var profileImage: RoundImageView!

    @IBOutlet weak var nameLabel: UILabel!

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


    func update(look: Look) {

        nameLabel.text = look.profileName

        do {

            let profileUrl = try look.profileUrl.asURL()

            profileImage.af_setImage(withURL: profileUrl, placeholderImage: placeholderImage)

            let lookUrl = try look.lookUrl.asURL()

            lookImage.af_setImage(withURL: lookUrl)

        } catch let error {

            Flurry.logError("\(self.cardViewDomainError).update.image.url", message: error.localizedDescription, error: error)
        }
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
