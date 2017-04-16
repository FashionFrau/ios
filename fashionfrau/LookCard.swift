//
//  LookCard.swift
//  fashionfrau
//
//  Created by Nilson Junior on 11/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation

class LookCardBuilder {

    var profileUrlString: String?

    var profileName: String?

    var lookUrlString: String?

    var purchaseUrl: String?

    var gallery: [String]?

    typealias BuilderClosure = (LookCardBuilder) -> ()

    init(buildClosure: BuilderClosure) {

        buildClosure(self)
    }

}

struct LookCard {

    let profileUrl: URL

    let profileName: String

    let lookUrl: URL

    let purchaseUrl: URL?

    let gallery: [URL]

    init?(builder: LookCardBuilder) throws {

        // Mandatory
        if let lookUrl = builder.lookUrlString, let profileName = builder.profileName, let profileUrl = builder.profileUrlString, let gallery = builder.gallery {

            self.profileName = profileName

            self.profileUrl =  try profileUrl.asURL()

            self.lookUrl = try lookUrl.asURL()

            var galleryUrl = [URL]()

            for urlString in gallery {

                let url = try urlString.asURL()

                galleryUrl.append(url)
            }

            self.gallery = galleryUrl

        } else {

            throw LookError.MissingField
        }
        
        // Optional
        if  let purchaseUrl = builder.purchaseUrl {
            
            self.purchaseUrl = try purchaseUrl.asURL()
            
        }else {
            
            self.purchaseUrl = nil
        }
    }
}
