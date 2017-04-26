//
//  MiniLookFavorite.swift
//  fashionfrau
//
//  Created by Nilson Junior on 16/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation

class MiniLookFavoriteBuilder {

    var profileUrlString: String?

    var profileName: String?

    var lookUrlString: String?

    var likes: Int?

    var hashtag: String?

    typealias BuilderClosure = (MiniLookFavoriteBuilder) -> ()

    init(buildClosure: BuilderClosure) {

        buildClosure(self)
    }
}

struct MiniLookFavorite {

    let profileUrl: URL

    let profileName: String

    let lookUrl: URL

    let likes: Int

    let hashtag: String

    init?(builder: MiniLookFavoriteBuilder) throws {

        // Mandatory
        guard let lookUrl = builder.lookUrlString else {
            throw MiniLookError.MissingField("lookUrl")
        }
        guard let profileName = builder.profileName else {
            throw MiniLookError.MissingField("profileName")
        }
        guard let profileUrl = builder.profileUrlString else {
            throw MiniLookError.MissingField("profileUrl")
        }
        guard let likes = builder.likes else {
            throw MiniLookError.MissingField("likes")
        }
        guard let hashtag = builder.hashtag  else {
            throw MiniLookError.MissingField("hashtag")
        }

        self.profileName = profileName

        self.profileUrl =  try profileUrl.asURL()

        self.lookUrl = try lookUrl.asURL()

        self.likes = likes
        
        self.hashtag = hashtag
    }
}
