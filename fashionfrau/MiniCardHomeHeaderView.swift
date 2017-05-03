//
//  MiniCardHomeHeaderView.swift
//  fashionfrau
//
//  Created by Nilson Junior on 23.04.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class MiniCardHomeHeaderView: UICollectionReusableView {

    fileprivate let miniCardHomeHeaderViewDomainError = "com.fashionfrau.mini-card-home-header.error"

    var model: User? {
        didSet{
            updateUI()
        }
    }

    @IBOutlet weak var profileImage: RoundImageView!

    @IBOutlet weak var postsNumber: UILabel!

    @IBOutlet weak var likedNumber: UILabel!

    @IBOutlet weak var likesNumber: UILabel!

    @IBOutlet weak var backgrounRecentLikedView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgrounRecentLikedView.layer.borderColor = UIColor.white.cgColor
        self.backgrounRecentLikedView.layer.borderWidth = 1
    }

    override func prepareForReuse() {

        super.prepareForReuse()

        profileImage.af_cancelImageRequest()
        profileImage.layer.removeAllAnimations()
        profileImage.image = nil
    }

}

extension MiniCardHomeHeaderView {

    fileprivate func updateUI() {

        do {
            let url = try model!.profileUrl.asURL()

            profileImage.af_setImage(withURL: url)

        } catch let error {

            Flurry.logError("\(self.miniCardHomeHeaderViewDomainError).profile-image.url", message: error.localizedDescription, error: error)
        }

        postsNumber.text = String(model!.posts)

        likedNumber.text = String(model!.liked)

        likesNumber.text = String(model!.likes)
    }
}
