//
//  DataSource.swift
//  fashionfrau
//
//  Created by Nilson Junior on 16/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation

private let ngrok = "8d033750"
public let baseUrl = "https://\(ngrok).ngrok.io"
//public let baseUrl = "http://0.0.0.0:3000"

//public let regexBaseUrl = "^http:\\/\\/0.0.0.0.+api\\/auth\\/callback"
public let regexBaseUrl = "^https:\\/\\/\(ngrok).+api\\/auth\\/callback"
//public let regexBaseUrl = "^http:\\/\\/fashionfrau.+api\\/auth\\/callback"


//public let authUrl = "https://api.instagram.com/oauth/authorize/?client_id=b0a5c417a94a43df83943434131f820b&redirect_uri=http%3A%2F%2F0.0.0.0%3A3000%2Fapi%2Fauth%2Fcallback&response_type=code&scope=basic+public_content+likes+relationships"

public let authUrl = "https://api.instagram.com/oauth/authorize/?client_id=b0a5c417a94a43df83943434131f820b&redirect_uri=https%3A%2F%2F\(ngrok).ngrok.io%2Fapi%2Fauth%2Fcallback&response_type=code&scope=basic+public_content+likes+relationships"



public let whiteListUrl = ["0.0.0.0", ngrok, "api.instagram", "www.instagram.com", "instagram.com"]

var defaultHeaders = ["Accept": "application/json"]

struct ErrorResponse {
    public let response: HTTPURLResponse?
    public let error: Error?

    public init(response: HTTPURLResponse?, error: Error?) {
        self.response = response
        self.error = error
    }
}
