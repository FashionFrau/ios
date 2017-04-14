//
//  CustomOverlayView.swift
//  fashionfrau
//
//  Created by Nilson Junior on 14/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import Koloda


private let overlayLikeImage = "Like"

class CustomOverlayView: OverlayView {

    @IBOutlet weak var likeImageView: UIImageView!

    override var overlayState: SwipeResultDirection? {
        didSet {
            switch overlayState {
            case .left? :
                backgroundColor = UIColor.clear
            case .right? :
                likeImageView.image = UIImage(named: overlayLikeImage)
                backgroundColor = UIColor.fashionfrau.withAlphaComponent(0.1)
            default:
                backgroundColor = UIColor.clear
            }
        }
    }

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
