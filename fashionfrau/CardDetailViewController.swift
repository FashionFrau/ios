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

    fileprivate let cardDetailViewControllerDomainError = "com.fashionfrau.card-detail-view-controller.error"

    fileprivate let placeholderImage = UIImage(named: Images.ProfilePlaceHolder)

    @IBOutlet weak var profileImageView: RoundImageView!

    @IBOutlet weak var profileNameLabel: UILabel!

    @IBOutlet weak var sliderView: FFSliderView!

    @IBOutlet weak var descriptionView: UITextView!

    @IBOutlet var tapGesture: UITapGestureRecognizer!

    @IBOutlet weak var heartsView: UIView!
    
    var lookId: String!

    var look: Look?

    override func viewDidLoad() {
        super.viewDidLoad()

        tapGesture.addTarget(self, action: #selector(skipLook(_:)))
        sliderView.addGestureRecognizer(tapGesture)
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
        CardService.cs.get(cardId: lookId, success: { (look: Look) in

            self.look = look

            self.sliderView.datasource = self

            self.updateUI()

            self.sliderView.layoutSubviews()

        }) { (error: Error?) in

            Flurry.logError("\(self.cardDetailViewControllerDomainError).fetch", message: error?.localizedDescription, error: error)
        }
    }

    private func updateUI() {

        profileNameLabel.text = look!.profileName

        do {
            let url = try look!.profileUrl.asURL()

            profileImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)

        } catch let error {

            Flurry.logError("\(self.cardDetailViewControllerDomainError).update-ui.profile-image.url", message: error.localizedDescription, error: error)
        }

        descriptionView.text = look!.description

        if look!.userHasLiked {

            heartsView.isHidden = true

        } else {

            heartsView.isHidden = false
        }
    }
}

extension CardDetailViewController: FFSliderDataSource {

    func slider(ffSliderNumberOfSlides slider: FFSliderView) -> Int {
        return look?.gallery.count ?? 0
    }

    func slider(slider: FFSliderView, viewForSlideAtIndex index: Int) -> UIView {

        let imageView = UIImageView()

        do {
            let url = try look!.gallery[index].asURL()

            imageView.af_setImage(withURL: url)

            imageView.contentMode = .scaleAspectFill

        } catch let error {

            Flurry.logError("\(self.cardDetailViewControllerDomainError).slider.gallery-image.url", message: error.localizedDescription, error: error)
        }

        return imageView
    }
}
