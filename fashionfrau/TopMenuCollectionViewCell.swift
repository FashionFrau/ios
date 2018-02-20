//
//  TopMenuCollectionViewCell.swift
//  fashionfrau
//
//  Created by Nilson Junior on 20.02.18.
//  Copyright © 2018 Fashion Frau. All rights reserved.
//

import UIKit

class TopMenuCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!

    private var touchOn: Bool = false {
        didSet {
            if (touchOn) {
                selectCategory()
            } else {
                deselectCategory()
            }
        }
    }

    override func awakeFromNib() {
        categoryLabel.textColor = UIColor.white

        addBorderEffect()
    }

    var category: String? {
        didSet {
            updateUI()
        }
    }

    func updateUI() {
        categoryLabel.text = category
    }

    func didTouchIn() {
        touchOn = touchOn ? false : true
    }

    private func selectCategory() {
        categoryLabel.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        categoryLabel.layer.borderWidth = 0
    }

    private func deselectCategory() {
        categoryLabel.backgroundColor = UIColor.clear
        categoryLabel.layer.borderWidth = 0.5
    }

    private func addBorderEffect() {
        categoryLabel.layer.borderColor = UIColor.white.cgColor
        categoryLabel.layer.borderWidth = 0.5
        categoryLabel.layer.cornerRadius = frame.size.height / 4
        categoryLabel.layer.masksToBounds = true
    }
}
