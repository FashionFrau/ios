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

    var user: User?

    fileprivate let mainViewControllerDomainError = "com.fashionfrau.main-view-controller.error"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

            self.user = user

            redirectToTutorial()
        } else {

            showMessageError()
        }

        if let error = error {

            Flurry.logError("\(self.mainViewControllerDomainError).did-finish- login", message: error.localizedDescription, error: error)
        }
    }

    private func showMessageError() {

        let alert = JSSAlertView().show(self, title: "Ops", text: Translations.SomethingWentWrong, 			                                    buttonText: Translations.Ok, color: UIColor.fashionfrau)

        let font = "Courgette-Regular"

        alert.setTitleFont(font)

        alert.setTextFont(font)

        alert.setButtonFont(font)

        alert.setTextTheme(.light)
    }

    private func redirectToTutorial() {

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

extension MainViewController: BWWalkthroughViewControllerDelegate {

    func walkthroughCloseButtonPressed() {

        self.dismiss(animated: false, completion: {

            if self.user!.askUserFollow {

                self.showMessageAskUserFollow()
            }
        })
    }

    private func showMessageAskUserFollow() {


        let alert = JSSAlertView().show(self, title: Translations.AskUserFollowTitle,
                                            buttonText: Translations.Ok, cancelButtonText: Translations.Cancel, color: UIColor.fashionfrau)

        let font = "Courgette-Regular"

        alert.setTitleFont(font)

        alert.setTextFont(font)

        alert.setButtonFont(font)

        alert.setTextTheme(.light)

        alert.addAction(followUs)
    }

    private func followUs() {
        print("follow")
    }
}


