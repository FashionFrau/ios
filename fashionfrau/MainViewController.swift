//
//  MainViewController.swift
//  fashionfrau
//
//  Created by Nilson Junior on 09/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import JSSAlertView
import Flurry_iOS_SDK
import BWWalkthrough

class MainViewController: UIViewController {

    fileprivate let mainViewControllerDomainError = "com.fashionfrau.main-view-controller.error"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InstagramSegue" {

            let loginViewController = segue.destination as! LoginWebViewController

            loginViewController.delegate = self
        }
    }
}

extension MainViewController: LoginFlowDelegate {

    func didFinishLogin(user: User?, error: Error?) {

        if let user = user {

            do {

                try UserService.us.saveCurrentUser(user: user)

                defaultHeaders["Authorization"] = user.authToken

                redirectToTutorial()

            } catch let error {

                defaultHeaders.removeValue(forKey: "Authorization")

                Flurry.logError("\(self.mainViewControllerDomainError).did-finish-login:save-user", message: error.localizedDescription, error: error)
            }
        } else {

            showMessageError(title: "Ops", text: Translations.SomethingWentWrong)
        }

        if let error = error {

            Flurry.logError("\(self.mainViewControllerDomainError).did-finish-login", message: error.localizedDescription, error: error)
        }
    }
}

extension MainViewController: BWWalkthroughViewControllerDelegate {

    func walkthroughCloseButtonPressed() {

        self.dismiss(animated: false, completion: {

            do {
                let user = try UserService.us.getCurrentUser()

                if user.askUserFollow {

                    self.askUserToFollowUs(self.actionFollowUs)

                } else {

                    self.redirectToApp()
                }
            } catch let error {

                Flurry.logError("\(self.mainViewControllerDomainError).walk-through:get-current-user", message: error.localizedDescription, error: error)
            }
        })
    }

    private func actionFollowUs() {

        UserService.us.askUserFollow()

        self.redirectToApp()
    }

    func redirectToTutorial() {

        let stb = UIStoryboard(name: "Tutorial", bundle: nil)

        let walkthrough = stb.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController

        let page_one = stb.instantiateViewController(withIdentifier: "walk1")

        let page_two = stb.instantiateViewController(withIdentifier: "walk2")

        let page_three = stb.instantiateViewController(withIdentifier: "walk3")

        let page_four = stb.instantiateViewController(withIdentifier: "walk4")

        walkthrough.delegate = self

        walkthrough.add(viewController:page_one)

        walkthrough.add(viewController:page_two)

        walkthrough.add(viewController:page_three)

        walkthrough.add(viewController:page_four)
        
        self.present(walkthrough, animated: true, completion: nil)
    }
    
}


