//
//  CardDetailViewController.swift
//  fashionfrau
//
//  Created by Nilson Junior on 14/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import AlamofireImage


class CardDetailViewController: UIViewController {

    private var _look: LookCard!

    @IBOutlet weak var profileImageView: RoundImageView!

    @IBOutlet weak var profileNameLabel: UILabel!

    @IBOutlet weak var sliderView: FFSliderView!

    var look: LookCard {
        get {
            return _look
        }
        set {
            _look = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSlider()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        profileNameLabel.text = look.profileName

        profileImageView.af_setImage(withURL: look.profileUrl)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var prefersStatusBarHidden: Bool { return true }

    @IBAction func likeLook(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func skipLook(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    private func setupSlider() {

        sliderView.datasource  = self
    }
}

extension CardDetailViewController: FFSliderDataSource {

    func slider(ffSliderNumberOfSlides slider: FFSliderView) -> Int {
        return look.gallery.count
    }

    func slider(slider: FFSliderView, viewForSlideAtIndex index: Int) -> UIView {
        let imageView = UIImageView()

        let url = look.gallery[index]

        imageView.af_setImage(withURL: url)

        imageView.contentMode = .scaleAspectFill
        return imageView
    }
}
