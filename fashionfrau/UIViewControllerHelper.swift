//
//  UIViewControllerHelper.swift
//  fashionfrau
//
//  Created by Nilson Junior on 23.07.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func isUnauthorized(response: HTTPURLResponse?) -> Bool {

        if let response = response {
            return response.statusCode == 401 ? true : false
        }
        return false
    }

    func redirectToLogin() {

        let stb = UIStoryboard(name: "Main", bundle: nil)

        let mainController = stb.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController

        self.present(mainController, animated: false, completion: nil)
    }

    func redirectToApp() {

        let stb = UIStoryboard(name: "App", bundle: nil)

        let tab = stb.instantiateViewController(withIdentifier: "TabBarController") as! FFTabBarController

        self.present(tab, animated: true, completion: nil)
    }

    func urlMatchDomain(url: URL) -> Bool {

        if let _ = url.absoluteString.range(of: regexBaseUrl, options: .regularExpression) {

            return true
        }
        return false
    }

    func isWhiteListedDomain(url: URL) -> Bool {

        if let host = url.host {

            return whiteListUrl.contains(host)
        }

        return false
    }
}
