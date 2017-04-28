//
//  MiniCardHomeHeaderView.swift
//  fashionfrau
//
//  Created by Nilson Junior on 23.04.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit

class MiniCardHomeHeaderView: UICollectionReusableView {

    var model: User? {
        didSet{
            updateUI()
        }
    }

    @IBOutlet weak var profileImage: RoundImageView!

    @IBOutlet weak var postsNumber: UILabel!

    @IBOutlet weak var likedNumber: UILabel!

    @IBOutlet weak var likesNumber: UILabel!

    @IBOutlet weak var backgrounRecentLikedView: UIView! {
        didSet{
            self.backgrounRecentLikedView.layer.borderColor = UIColor.white.cgColor
            self.backgrounRecentLikedView.layer.borderWidth = 1
        }
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
        profileImage.af_setImage(withURL: model!.profileUrl)

        postsNumber.text = String(model!.posts)

        likedNumber.text = String(model!.liked)

        likesNumber.text = String(model!.likes)
    }
}