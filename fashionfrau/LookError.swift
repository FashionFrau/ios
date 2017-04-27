//
//  LookError.swift
//  fashionfrau
//
//  Created by Nilson Junior on 11/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation

let MiniLookDomainError = "mini-look-domain"
let LookDomainError = "look-domain"

enum LookError: Error {
    case MissingField(String)
}

enum MiniLookError: Error {
    case MissingField(String)
    case ParseDate
}
