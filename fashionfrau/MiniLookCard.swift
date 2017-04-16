//
//  MiniLookCard.swift
//  fashionfrau
//
//  Created by Nilson Junior on 16/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation

class MiniLookCardBuilder {

    var profileUrlString: String?

    var profileName: String?

    var lookUrlString: String?

    var likes: Int?

    var hashtag: String?

    typealias BuilderClosure = (MiniLookCardBuilder) -> ()

    init(buildClosure: BuilderClosure) {

        buildClosure(self)
    }

}

struct MiniLookCard {

    let profileUrl: URL

    let profileName: String

    let lookUrl: URL

    let likes: Int

    let hashtag: String

    init?(builder: MiniLookCardBuilder) throws {

        // Mandatory
        if let lookUrl = builder.lookUrlString, let profileName = builder.profileName, let profileUrl = builder.profileUrlString, let likes = builder.likes, let hashtag = builder.hashtag {

            self.profileName = profileName

            self.profileUrl =  try profileUrl.asURL()

            self.lookUrl = try lookUrl.asURL()

            self.likes = likes
            
            self.hashtag = hashtag
            
        } else {
            
            throw LookError.MissingField
        }
    }
}
