//
//  MiniLookFavoriteDTO.swift
//  fashionfrau
//
//  Created by Nilson Junior on 17/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation
import ObjectMapper

class MiniLookFavoriteDTO: Mappable {

    var date: String?

    var looks: [LookDTO]?

    required init?(map: Map) {
        /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    }

    func mapping(map: Map) {
        date <- map["date"]

        looks <- map["looks"]
    }
}
