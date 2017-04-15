//
//  Look.swift
//  fashionfrau
//
//  Created by Nilson Junior on 11/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation

class LookBuilder {

    var profileUrl: String?

    var profileName: String?

    var lookUrl: String?

    var gallery: [String]?

    typealias BuilderClosure = (LookBuilder) -> ()


    init(buildClosure: BuilderClosure) {

        buildClosure(self)

    }
}

struct Look {

    let profileUrl: URL

    let profileName: String

    let lookUrl: URL

    let gallery: [URL]

    init?(builder: LookBuilder) throws {

        if let lookUrl = builder.lookUrl, let profileName = builder.profileName, let profileUrl = builder.profileUrl, let gallery = builder.gallery {

            self.profileName = profileName

            var galleryUrl = [URL]()

            for urlString in gallery {
                if let url = URL(string: urlString) {
                    galleryUrl.append(url)
                } else {
                    throw LookError.BadUrl
                }
            }

            self.gallery = galleryUrl

            if let urlLook = URL(string: lookUrl), let urlProfile = URL(string: profileUrl) {

                self.lookUrl = urlLook

                self.profileUrl = urlProfile

            } else {

                throw LookError.BadUrl
                
            }
            
        } else {
            
            throw LookError.MissingField
            
        }
    }
}
