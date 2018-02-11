//
//  Look.swift
//  fashionfrau
//
//  Created by Nilson Junior on 11/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation

struct Look: ResponseObjectSerializable, ResponseCollectionSerializable {

    var id: String

    var profileUrl: String

    var profileName: String

    var lookUrl: String

    var purchaseUrl: String?

    var gallery: [String]

    var description: String?

    var userHasLiked: Bool = false


    init?(response: HTTPURLResponse, representation: Any) {

        guard
            let representation = representation as? [String: Any],

            let id = representation["id"] as? String,

            let profileUrl = representation["profileUrl"] as? String,

            let profileName = representation["profileName"] as? String,

            let lookUrl = representation["lookUrl"] as? String,

            let gallery = representation["gallery"] as? [String]

            else { return nil }

        self.id = id

        self.profileName = profileName

        self.profileUrl = profileUrl

        self.lookUrl = lookUrl

        self.gallery = gallery

        // Optional

        if let description = representation["description"] as? String {

            self.description = description
        }

        if let purchaseUrl = representation["purchaseUrl"] as? String {

            self.purchaseUrl = purchaseUrl
        }

        if let userHasLiked = representation["userHasLiked"] as? Bool {

            self.userHasLiked = userHasLiked
        }
    }
    
}
