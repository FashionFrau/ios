//
//  MiniCardFavoriteCell.swift
//  fashionfrau
//
//  Created by Nilson Junior on 15/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import AlamofireImage
import Flurry_iOS_SDK


class MiniCardFavoriteCell: UICollectionViewCell {

    fileprivate let miniCardFavoriteCellDomainError = "com.fashionfrau.mini-card-favorite-cell.error"

    fileprivate let placeholderImage = UIImage(named: Images.ProfilePlaceHolder)

    var model: MiniLookFavorite? {
        didSet {
            updateUI()
        }
    }


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
}

extension MiniCardFavoriteCell {

    fileprivate func updateUI() {

        setupProfileImage()

        setupLookImage()

        profileNameLabel.text = model!.profileName

        likesLabel.text = "\(model!.likes)"

        hashtagLabel.text = model!.hashtag
        
    }


    fileprivate func shadowEffect() {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 10
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }

    fileprivate func setupProfileImage() {
        do {
            let url = try model!.profileUrl.asURL()

            profileImage.af_setImage(withURL: url, placeholderImage: placeholderImage)

        } catch let error {

            Flurry.logError("\(self.miniCardFavoriteCellDomainError).profile-image.url", message: error.localizedDescription, error: error)
        }
    }

    fileprivate func setupLookImage() {
        do {
            let url = try model!.lookUrl.asURL()

            lookImage.af_setImage(withURL: url, placeholderImage: placeholderImage)

        } catch let error {

            Flurry.logError("\(self.miniCardFavoriteCellDomainError).look-image.url", message: error.localizedDescription, error: error)
        }
    }

}
