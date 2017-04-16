//
//  LookError.swift
//  fashionfrau
//
//  Created by Nilson Junior on 11/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation


enum LookError: Error {
    case MissingField
}

enum MiniLookCardError: Error {
    case MissingField
    case ParseDate
}
