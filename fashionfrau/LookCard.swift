//
//  LookCard.swift
//  fashionfrau
//
//  Created by Nilson Junior on 11/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation

class LookCardBuilder {

    var id: String?

    var profileUrlString: String?

    var profileName: String?

    var lookUrlString: String?

    var purchaseUrl: String?

    var gallery: [String]?

    var description: String?

    typealias BuilderClosure = (LookCardBuilder) -> ()

    init(buildClosure: BuilderClosure) {

        buildClosure(self)
    }


    static func map(dto: LookDTO) -> LookCardBuilder{
        return LookCardBuilder {

            $0.id = dto.id

            $0.profileName = dto.profileName

            $0.profileUrlString = dto.profileUrlString

            $0.lookUrlString = dto.lookUrlString

            $0.gallery = dto.gallery

            $0.description = dto.description
        }
    }
}

struct LookCard {

    let id: String

    let profileUrl: URL

    let profileName: String

    let lookUrl: URL

    let purchaseUrl: URL?

    let gallery: [URL]

    let description: String

    init?(builder: LookCardBuilder) throws {

        // Mandatory
        guard let id = builder.id  else {
            throw LookError.MissingField("id")
        }
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
        guard let description = builder.description  else {
            throw LookError.MissingField("description")
        }

        self.id = id

        self.profileName = profileName

        self.profileUrl =  try profileUrl.asURL()

        self.lookUrl = try lookUrl.asURL()

        var galleryUrl = [URL]()

        for urlString in gallery {

            let url = try urlString.asURL()

            galleryUrl.append(url)
        }

        self.gallery = galleryUrl
        
        self.description = description
        
        // Optional
        if  let purchaseUrl = builder.purchaseUrl {
            
            self.purchaseUrl = try purchaseUrl.asURL()
            
        } else {
            
            self.purchaseUrl = nil
        }
    }
}
