//
//  DataSource.swift
//  fashionfrau
//
//  Created by Nilson Junior on 16/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation

public let baseUrl = "https://demo5494816.mockable.io"

//public let regexBaseUrl = "^https:\\/\\/localhost.+api\\/auth\\/callback"
public let regexBaseUrl = "^https:\\/\\/9b4a42a0.ngrok.io.+api\\/auth\\/callback"
//public let regexBaseUrl = "^http:\\/\\/fashionfrau.+api\\/auth\\/callback"


public let whitListUrl = ["localhost", "9b4a42a0.ngrok.io", "api.instagram", "www.instagram.com", "instagram.com"]

var defaultHeaders = ["Accept": "application/json"]
