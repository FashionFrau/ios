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

    var id: String?

    var profileUrl: String?

    var profileName: String?

    var posts: Int?

    var liked: Int?

    var likes: Int?

    required init?(map: Map) {
        /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    }

    func mapping(map: Map) {

        id <- map["id"]

        profileUrl <- map["profileUrl"]

        profileName <- map["profileName"]

        posts <- map["posts"]

        liked <- map["liked"]

        likes <- map["likes"]
    }

}
