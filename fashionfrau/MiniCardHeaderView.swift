//
//  MiniCardHeaderView.swift
//  fashionfrau
//
//  Created by Nilson Junior on 15/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit

class MiniCardHeaderView: UICollectionReusableView {
        
    @IBOutlet weak var dotView: UIView!

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var dayLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        dotView.layer.cornerRadius = dotView.frame.size.height / 2
        dotView.layer.masksToBounds = true


    }
}
