//
//  LoginWebViewController.swift
//  fashionfrau
//
//  Created by Nilson Junior on 16.05.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import WebKit
import Flurry_iOS_SDK

protocol LoginFlowDelegate: class {

    func didFinishLogin(user: User?, error: Error?)
}

enum ResponseError: Error {
    case notHTTPURLResponse
    case statusCodeNot200
    case createUserError
    case parseJsonError
    case authDomainNotMatch
    case failNavigation
    case domainNotWhiteListed
}

class LoginWebViewController: UIViewController {

    fileprivate let loginWebViewControllerDomainError = "com.fashionfrau.login-web-view-controller.error"

//    private let authUrl = "https://api.instagram.com/oauth/authorize/?client_id=b0a5c417a94a43df83943434131f820b&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fapi%2Fauth%2Fcallback&response_type=code&scope=basic+public_content+likes"

    private let authUrl = "https://api.instagram.com/oauth/authorize/?client_id=b0a5c417a94a43df83943434131f820b&redirect_uri=https%3A%2F%2F9b4a42a0.ngrok.io%2Fapi%2Fauth%2Fcallback&response_type=code&scope=basic+public_content+likes"

    var webView: WKWebView!

    public weak var delegate: LoginFlowDelegate?

    var currentUser: User?

    var authError: Error?

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
}

extension LoginWebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        if let url = webView.url {

            if self.urlMatchDomain(url: url) {

                dismiss(animated: false, completion: {

                    webView.evaluateJavaScript("document.documentElement.innerText.toString()") { (representation: Any?, error: Error?) in

                        if let error = error {
                            self.authError = error
                            return
                        }

                        do {
                            if let representation = representation as? String {

                                let data = representation.data(using: String.Encoding.utf8, allowLossyConversion: false)

                                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]

                                if let json = json {

                                    let user = User(representation: json)

                                    if let user = user {

                                        self.currentUser = user

                                    } else {

                                        let exception = AuthException(representation: json)

                                        if let exception = exception {

                                            self.authError =  exception.error
                                        } else {

                                            self.authError = ResponseError.createUserError
                                        }
                                    }
                                } else {

                                    self.authError = ResponseError.parseJsonError
                                }
                            } else {

                                self.authError = ResponseError.parseJsonError
                            }
                        } catch let error {

                            self.authError = error
                        }

                        self.delegate?.didFinishLogin(user: self.currentUser, error: self.authError)
                    }
                })
            } else if !isWhiteListedDomain(url: url){

                dismiss(animated: false, completion: { 

                    self.authError = ResponseError.domainNotWhiteListed

                    self.delegate?.didFinishLogin(user: self.currentUser, error: self.authError)
                })
            } else {

                 Flurry.logError("\(self.loginWebViewControllerDomainError).did-finish", message: "Login flow fail. Reason: Unknown", error: ResponseError.failNavigation)
            }
        }
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        dismiss(animated: false) {
            
            self.authError = ResponseError.failNavigation

            self.delegate?.didFinishLogin(user: self.currentUser, error: self.authError)
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        dismiss(animated: false) {
            
            self.authError = ResponseError.failNavigation

            self.delegate?.didFinishLogin(user: self.currentUser, error: self.authError)
        }
    }

    private func urlMatchDomain(url: URL) -> Bool {
        
        if let _ = url.absoluteString.range(of: regexBaseUrl, options: .regularExpression) {
            
            return true
        }
        return false
    }

    private func isWhiteListedDomain(url: URL) -> Bool {

        if let host = url.host {

            return whitListUrl.contains(host)
        }

        return false
    }
}

