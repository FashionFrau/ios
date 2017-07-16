//
//  AuthException.swift
//  fashionfrau
//
//  Created by Nilson Junior on 16.07.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation


class AuthException {

    var errorType: String

    var errorMessage: String

    var code: Int

    var error: Error

    init?(representation: Any?) {

        guard
            let representation = representation as? [String: Any],

            let errorType = representation["error_type"] as? String,

            let errorMessage = representation["error_message"] as? String,

            let code = representation["code"] as? Int

            else { return nil }


        self.errorType = errorType

        self.errorMessage = errorMessage

        self.code = code

        self.error = NSError(domain: errorType, code: code, userInfo: nil)
    }
}
