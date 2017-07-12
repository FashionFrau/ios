//
//  LoginWebViewController.swift
//  fashionfrau
//
//  Created by Nilson Junior on 16.05.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit


class LoginWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let link = "https://api.instagram.com/oauth/authorize/?client_id=b0a5c417a94a43df83943434131f820b&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fapi%2Fauth%2Fcallback&response_type=code&scope=basic+public_content+likes"

//        let link = "https://api.instagram.com/oauth/authorize/?client_id=b0a5c417a94a43df83943434131f820b&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fusers%2Fsign_in&response_type=code&scope=basic+public_content+likes"
        let url = URL(string: link)!
//        let request = URLRequest(url: url)

        loadURL(url: url)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadURL(url: URL!) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        var muableRequest = URLRequest(url: url)
        muableRequest.setValue("WhateverYouWant", forHTTPHeaderField: "x-YourHeaderField")

        let task = session.dataTask(with: muableRequest) { (data, response, error) in
//TIMEOUT
            guard error == nil else {
                print(error!)
                // Here, you have to handle the error ...
                return
            }

            if let response = response {
                var mimeType = ""
                if response.mimeType != nil {
                    mimeType = response.mimeType!
                }

                var encoding = ""
                if response.textEncodingName != nil {
                    encoding = response.textEncodingName!
                }

                if let httpResponse = response as? HTTPURLResponse {

                    //                    error: access_denied

                    //                    error_reason: user_denied
                    
                    //                    error_description: The user denied your request

                    print("HTTP Status code is \(httpResponse.statusCode)")

                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary


                        if let parseJSON = json {
                            print(parseJSON)
                            self.dismiss(animated: true, completion: nil)
                        }
                    } catch {
                        print(error)
                    }
                }
                
                self.webView.load(data!, mimeType: mimeType, textEncodingName: encoding, baseURL: url)
            }
        }
        task.resume()
    }

}

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
