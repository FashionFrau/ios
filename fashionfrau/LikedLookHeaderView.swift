//
//  LikedLookHeaderView.swift
//  fashionfrau
//
//  Created by Nilson Junior on 23.04.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class LikedLookHeaderView: UICollectionReusableView {

    fileprivate let homeHeaderViewDomainError = "com.fashionfrau.home-header.error"

    fileprivate let placeholderImage = UIImage(named: Images.ProfilePlaceHolder)
    
    var model: CurrentUser? {
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

extension LikedLookHeaderView {

    fileprivate func updateUI() {

        do {
            let url = try model!.profilePicture?.asURL()

            profileImage.af_setImage(withURL: url!, placeholderImage: placeholderImage)

        } catch let error {

            Flurry.logError("\(self.homeHeaderViewDomainError).profile-image.url", message: error.localizedDescription, error: error)
        }

        postsNumber.text = String(describing: model!.posts!)

        likedNumber.text = String(describing: model!.liked!)

        likesNumber.text = String(describing: model!.likes!)
    }
}
