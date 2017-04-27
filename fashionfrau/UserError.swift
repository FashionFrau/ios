//
//  UserError.swift
//  fashionfrau
//
//  Created by Nilson Junior on 26.04.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation

let UserDomainError = "user-domain"

enum UserError: Error {
    case MissingField(String)
}
