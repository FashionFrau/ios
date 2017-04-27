//
//  UserDTO.swift
//  fashionfrau
//
//  Created by Nilson Junior on 27.04.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation
import ObjectMapper

class UserDTO: Mappable {

    var profileUrl: String?

    var profileName: String?

    required init?(map: Map) {
        /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    }

    func mapping(map: Map) {
        profileUrl <- map["profileUrl"]

        profileName <- map["profileName"]
    }

}
