//
//  CardDetailViewController.swift
//  fashionfrau
//
//  Created by Nilson Junior on 14/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import AlamofireImage
import Flurry_iOS_SDK

class CardDetailViewController: UIViewController {

    private let cardDetailViewControllerDomainError = "card-detail-view-controller"

    @IBOutlet weak var profileImageView: RoundImageView!

    @IBOutlet weak var profileNameLabel: UILabel!

    @IBOutlet weak var sliderView: FFSliderView!

    @IBOutlet weak var descriptionView: UITextView!

    var idCard: String!

    var look: LookCard?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if look == nil {
            fetch()
        } else {
            sliderView.datasource = self
            self.updateUI()
        }
    }

    override var prefersStatusBarHidden: Bool { return true }

    @IBAction func likeLook(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func skipLook(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    private func fetch() {
        CardService.cs.get(cardId: idCard, card: { (card: LookCard?, error: Error?) in

            if error == nil {

                self.look = card

                self.sliderView.datasource = self

                self.updateUI()

                self.sliderView.layoutSubviews()

            } else {
                Flurry.logError("\(self.cardDetailViewControllerDomainError).fetch", message: error?.localizedDescription, error: error)
            }
        })
    }

    private func updateUI() {
        profileNameLabel.text = look!.profileName

        profileImageView.af_setImage(withURL: look!.profileUrl)

        descriptionView.text = look!.description

    }
}

extension CardDetailViewController: FFSliderDataSource {

    func slider(ffSliderNumberOfSlides slider: FFSliderView) -> Int {
        return look?.gallery.count ?? 0
    }

    func slider(slider: FFSliderView, viewForSlideAtIndex index: Int) -> UIView {
        let imageView = UIImageView()

        if let look = look {

            let url = look.gallery[index]

            imageView.af_setImage(withURL: url)
        }
        
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
}
