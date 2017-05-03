//
//  MiniCardHomeCell.swift
//  fashionfrau
//
//  Created by Nilson Junior on 22.04.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import AlamofireImage
import Flurry_iOS_SDK

class MiniCardHomeCell: UICollectionViewCell {

    fileprivate let miniCardHomeCellDomainError = "com.fashionfrau.mini-card-home-cell.error"

    fileprivate let placeholderImage = UIImage(named: Images.ProfilePlaceHolder)

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

        seasonLabel.layer.cornerRadius = 5
        seasonLabel.layer.masksToBounds = true

        shadowEffect()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        profileImage.af_cancelImageRequest()
        profileImage.layer.removeAllAnimations()
        profileImage.image = nil

        lookImage.af_cancelImageRequest()
        lookImage.layer.removeAllAnimations()
        lookImage.image = nil

    }
}

extension MiniCardHomeCell {

    func updateUI() {

        setupProfileImage()

        setupLookImage()

        profileNameLabel.text = model!.profileName

        likesLabel.text = "\(model!.likes)"

        seasonLabel.text = " \(model!.season) "

        seasonBackground.backgroundColor = seasonColor()

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

    fileprivate func setupProfileImage() {
        do {
            let url = try model!.profileUrl.asURL()

            profileImage.af_setImage(withURL: url, placeholderImage: placeholderImage)

        } catch let error {

            Flurry.logError("\(self.miniCardHomeCellDomainError).profile-image.url", message: error.localizedDescription, error: error)
        }
    }

    fileprivate func setupLookImage() {
        do {
            let url = try model!.lookUrl.asURL()

            lookImage.af_setImage(withURL: url, placeholderImage: placeholderImage)

        } catch let error {

            Flurry.logError("\(self.miniCardHomeCellDomainError).look-image.url", message: error.localizedDescription, error: error)
        }
    }
}
