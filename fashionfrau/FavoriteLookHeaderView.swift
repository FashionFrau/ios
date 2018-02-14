//
//  FavoriteHeaderView.swift
//  fashionfrau
//
//  Created by Nilson Junior on 15/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import SwiftDate

class FavoriteLookHeaderView: UICollectionReusableView {

    var model: DateInRegion? {
        didSet {
            updateUI()
        }
    }

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var dayLabel: UILabel!

    func updateUI() {
        dateLabel.text = "\(model!.day)"

        dayLabel.text = model!.weekdayName.cut(at: 2)

    }
}
