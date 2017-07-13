//
//  LoginWebViewController.swift
//  fashionfrau
//
//  Created by Nilson Junior on 16.05.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

protocol LoginDataSource: class {

    var user: User { get set }

    var error: Error? { get set }
}

enum ResponseError: Error {
    case notHTTPURLResponse
    case statusCodeNot200
    case createUserError
    case parseJsonError
}

class LoginWebViewController: UIViewController {

    private let authUrl = "https://api.instagram.com/oauth/authorize/?client_id=b0a5c417a94a43df83943434131f820b&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fapi%2Fauth%2Fcallback&response_type=code&scope=basic+public_content+likes"

    @IBOutlet weak var webView: UIWebView!

    public weak var datasource: LoginDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadURL()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadURL() {

        guard let url = URL(string: authUrl) else { return }

        let config = URLSessionConfiguration.default

        let session = URLSession(configuration: config)

        var request = URLRequest(url: url)//, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0 )
        request.httpMethod = "GET"
        request.setValue("WhateverYouWant", forHTTPHeaderField: "x-YourHeaderField")


        let task = session.dataTask(with: request) { (data, response, error) in //TIMEOUT
            guard error == nil else {

                self.dismiss(animated: true, completion: {

                    self.datasource?.error = error
                })
                return
            }
            if let response = response {

                let mimeType = response.mimeType ?? ""

                let encoding = response.textEncodingName ?? ""

                guard let httpResponse = response as? HTTPURLResponse else {

                    self.dismiss(animated: true, completion: {

                        self.datasource?.error = ResponseError.notHTTPURLResponse
                    })
                    return
                }

                if httpResponse.statusCode == 200 {

                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String : Any]

                        if let parsedJson = json {

                            let user = User(response: httpResponse, representation: parsedJson)

                            if let user = user {

                                self.datasource?.user = user
                            } else {

                                self.datasource?.error = ResponseError.createUserError
                            }

                        } else {

                            self.datasource?.error = ResponseError.parseJsonError
                        }

                    } catch let error {
                        
                        self.datasource?.error = error
                    }

                } else {
                    
                    self.datasource?.error = ResponseError.statusCodeNot200
                }
                
                self.webView.load(data!, mimeType: mimeType, textEncodingName: encoding, baseURL: url)

                self.dismiss(animated: true, completion: nil)
            }
        }
        task.resume()
    }
    
}
