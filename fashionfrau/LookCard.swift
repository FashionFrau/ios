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
        guard let lookUrl = builder.lookUrlString  else {
            throw LookError.MissingField("lookUrl")
        }
        guard let profileName = builder.profileName  else {
            throw LookError.MissingField("profileName")
        }
        guard let profileUrl = builder.profileUrlString  else {
            throw LookError.MissingField("profileUrl")
        }
        guard let gallery = builder.gallery  else {
            throw LookError.MissingField("gallery")
        }

        self.profileName = profileName

        self.profileUrl =  try profileUrl.asURL()

        self.lookUrl = try lookUrl.asURL()

        var galleryUrl = [URL]()

        for urlString in gallery {

            let url = try urlString.asURL()

            galleryUrl.append(url)
        }

        self.gallery = galleryUrl


        // Optional
        if  let purchaseUrl = builder.purchaseUrl {

            self.purchaseUrl = try purchaseUrl.asURL()
            
        } else {
            
            self.purchaseUrl = nil
        }
    }
}
