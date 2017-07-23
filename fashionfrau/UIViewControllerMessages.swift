//
//  UIViewControllerMessages.swift
//  fashionfrau
//
//  Created by Nilson Junior on 23.07.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation
import UIKit
import JSSAlertView

let alertFont = "Baskerville"

extension UIViewController {

    func showMessageError(title: String, text: String) {

        let alert = JSSAlertView().show(self, title: title, text: text, buttonText: Translations.Ok, color: UIColor.fashionfrau)

        alert.setTitleFont(alertFont)

        alert.setTextFont(alertFont)

        alert.setButtonFont(alertFont)

        alert.setTextTheme(.light)
    }

    func askUserToFollowUs(_ action: @escaping ()->Void) {

        let alert = JSSAlertView().show(self, title: Translations.AskUserFollowTitle,
                                        buttonText: Translations.Ok, cancelButtonText: Translations.Cancel, color: UIColor.fashionfrau)

        alert.setTitleFont(alertFont)

        alert.setTextFont(alertFont)

        alert.setButtonFont(alertFont)

        alert.setTextTheme(.light)
        
        alert.addAction(action)
    }
}
