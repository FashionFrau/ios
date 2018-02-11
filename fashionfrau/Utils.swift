//
//  Utils.swift
//  hout
//
//  Created by Nilson Junior on 01.11.17.
//  Copyright © 2017 Nilson Junior. All rights reserved.
//

import UIKit

class Utils {

    class func canOpenURL(url: String) -> Bool {
        if let url = URL(string: url) {
            return canOpenURL(url: url)
        }
        return false
    }

    class func canOpenURL(url: URL?) -> Bool {
        guard let url = url else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    class func openURL(url: String) {
        if let url = URL(string: url) {
            openURL(url: url)
        } else {
            print("Cannot open url: \(url)")
        }
    }

    class func openURL(url: URL) {
        guard canOpenURL(url: url) else { return }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
