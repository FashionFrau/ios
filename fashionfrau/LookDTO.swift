//
//  LookDTO.swift
//  fashionfrau
//
//  Created by Nilson Junior on 16/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation
import ObjectMapper

class LookDTO: Mappable {

    var profileUrlString: String?

    var profileName: String?

    var lookUrlString: String?

    var likes: Int?

    var hashtag: String?

    var gallery: [String]?

    var season: String?

    required init?(map: Map) {
        /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    }

    func mapping(map: Map) {
        profileUrlString <- map["profileUrl"]

        profileName <- map["profileName"]

        lookUrlString <- map["lookUrl"]

        likes <- map["likes"]

        hashtag <- map["hashtag"]

        gallery <- map["gallery"]

        season <- map["season"]
    }
}
