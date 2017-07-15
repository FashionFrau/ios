//
//  LoginWebViewController.swift
//  fashionfrau
//
//  Created by Nilson Junior on 16.05.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import WebKit

protocol LoginDataSource: class {

    var user: User { get set }

    var error: Error? { get set }
}

enum ResponseError: Error {
    case notHTTPURLResponse
    case statusCodeNot200
    case createUserError
    case parseJsonError
    case authDomainNotMatch
}

class LoginWebViewController: UIViewController, WKNavigationDelegate {

    private let authUrl = "https://api.instagram.com/oauth/authorize/?client_id=b0a5c417a94a43df83943434131f820b&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fapi%2Fauth%2Fcallback&response_type=code&scope=basic+public_content+likes"

    var webView: WKWebView!

    public weak var datasource: LoginDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        let webConfiguration = WKWebViewConfiguration()

        webView = WKWebView(frame: .zero, configuration: webConfiguration)

        webView.navigationDelegate = self

        view = webView

        loadUrl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadUrl() {

        guard let url = URL(string: authUrl) else { return }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0 )

        request.httpMethod = "GET"

        webView.load(request)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        if let url = webView.url {
            dismiss(animated: true, completion: {
                if self.urlMatchDomain(url: url) {

                    webView.evaluateJavaScript("document.documentElement.innerText.toString()") { (representation: Any?, error: Error?) in

                        do {
                            if let representation = representation as? String {
                                let data = representation.data(using: String.Encoding.utf8, allowLossyConversion: false)

                                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]

                                if let json = json {

                                    let user = User(representation: json)

                                    if let user = user {

                                        self.datasource?.user = user

                                    } else {

                                        self.datasource?.error = ResponseError.createUserError
                                    }
                                } else {

                                    self.datasource?.error = ResponseError.parseJsonError
                                }
                            } else {

                                self.datasource?.error = ResponseError.parseJsonError
                            }
                        } catch let error {

                            self.datasource?.error = error
                        }
                    }
                } else {

                    self.datasource?.error = ResponseError.authDomainNotMatch
                }
            })
        }
    }
    
    
    private func urlMatchDomain(url: URL) -> Bool {
        
        if let _ = url.absoluteString.range(of: regexBaseUrl, options: .regularExpression) {
            
            return true
        }
        return false
    }
}
