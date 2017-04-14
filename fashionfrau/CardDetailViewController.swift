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

    private var _look: Look!

    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var profileNameLabel: UILabel!

    @IBOutlet weak var lookImageView: UIImageView!

    var look: Look {
        get {
            return _look
        }
        set {
            _look = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.layer.masksToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        profileNameLabel.text = look.profileName

        profileImageView.af_setImage(withURL: look.profileUrl)

        lookImageView.af_setImage(withURL: look.lookUrl)

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
    
}
