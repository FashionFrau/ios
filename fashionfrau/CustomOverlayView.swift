//
//  CustomOverlayView.swift
//  fashionfrau
//
//  Created by Nilson Junior on 14/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import Koloda




class CustomOverlayView: OverlayView {

    @IBOutlet weak var likeImageView: UIImageView!

    override var overlayState: SwipeResultDirection? {
        didSet {
            switch overlayState {
            case .left? :
                likeImageView.image = UIImage()
                backgroundColor = UIColor.clear
            case .right? :
                likeImageView.image = UIImage(named: Images.OverlayLikeImage)
                backgroundColor = UIColor.fashionfrau.withAlphaComponent(0.1)
            default:
                backgroundColor = UIColor.clear
            }
        }
    }
}
