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
import Koloda

protocol CardDetailDelegate {
    func didSwipeCard(cardId: String, in direction: SwipeResultDirection) -> Void
}

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

    var delegate: CardDetailDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        tapGesture.addTarget(self, action: #selector(closeLook(_:)))
        sliderView.addGestureRecognizer(tapGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if look == nil {
            loadData()
        } else {
            sliderView.datasource = self
            self.updateUI()
        }
    }

    override var prefersStatusBarHidden: Bool { return true }

    @IBAction func likeLook(_ sender: Any) {

        dismiss(animated: true, completion: {

            self.delegate?.didSwipeCard(cardId: self.lookId, in: .right)
        })
    }

    @IBAction func unlikeLook(_ sender: Any) {
        dismiss(animated: true, completion: {

            self.delegate?.didSwipeCard(cardId: self.lookId, in: .left)
        })
    }

    func closeLook(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    private func loadData() {

        CardService.cs.get(cardId: lookId, success: { (look: Look) in
            
            self.look = look

            self.sliderView.datasource = self

            self.updateUI()

            self.sliderView.layoutSubviews()

        }) { (errorResponse: ErrorResponse) in

            if self.isUnauthorized(response: errorResponse.response) {

                self.redirectToLogin()
            }

            Flurry.logError("\(self.cardDetailViewControllerDomainError).fetch", message: errorResponse.error?.localizedDescription, error: errorResponse.error)
        }
    }

    private func updateUI() {

        updateProfile()
        updateDescription()

        updateLikeSkipButton()
    }

    private func updateProfile() {
        setupOpenUserProfileInstagramAction()

        profileNameLabel.text = look!.profileName

        do {
            let url = try look!.profileUrl.asURL()

            profileImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)

        } catch let error {

            Flurry.logError("\(self.cardDetailViewControllerDomainError).update-ui.profile-image.url", message: error.localizedDescription, error: error)
        }
    }

    private func setupOpenUserProfileInstagramAction() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openUserProfileInstagram(_:)))
        gesture.numberOfTapsRequired = 1

        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(gesture)
    }

    @objc func openUserProfileInstagram(_ sender: UIButton) {
        let urlString = "instagram://user?username=\(look!.profileName)"
        openInstagram(urlString: urlString)
    }

    private func openInstagram(urlString: String) {
        do {
            let url = try urlString.asURL()
            Utils.openURL(url: url)
        } catch let error {
            Flurry.logError("\(self.cardDetailViewControllerDomainError).open-instagram", message: error.localizedDescription, error: error)
        }
    }

    @IBAction func didFollowClicked(_ sender: UIButton) {
        blinkButton(button: sender)

        let us = UserService.us
        guard let id = look?.id else { return }
        us.userFollowUsername(lookId: id)
    }

    private func updateDescription() {
        descriptionView.text = look!.description
    }

    func blinkButton(button: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.2, options: UIViewAnimationOptions.curveEaseOut, animations: {
            button.alpha = 0.0
        }, completion: nil)
    }

    private func updateLikeSkipButton() {
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

        let loadingImage = UIImage(gifName: Images.LoadingImages)
        let imageView = UIImageView(image: loadingImage)

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
