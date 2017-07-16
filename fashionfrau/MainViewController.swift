//
//  MainViewController.swift
//  fashionfrau
//
//  Created by Nilson Junior on 09/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

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
        print(user ?? "")
        print(error ?? "")
    }
}
