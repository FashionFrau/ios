//
//  MiniLookFavorite.swift
//  fashionfrau
//
//  Created by Nilson Junior on 16/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation

class MiniLookFavoriteBuilder {

    var id: String?

    var profileUrlString: String?

    var profileName: String?

    var lookUrlString: String?

    var likes: Int?

    var hashtag: String?

    typealias BuilderClosure = (MiniLookFavoriteBuilder) -> ()

    init(buildClosure: BuilderClosure) {

        buildClosure(self)
    }

    static func map(dto: LookDTO) -> MiniLookFavoriteBuilder {
        return MiniLookFavoriteBuilder {

            $0.id = dto.id

            $0.profileName = dto.profileName

            $0.profileUrlString = dto.profileUrlString

            $0.lookUrlString = dto.lookUrlString

            $0.likes = dto.likes

            $0.hashtag = dto.hashtag
        }
    }
}

struct MiniLookFavorite {

    let id: String
    
    let profileUrl: URL

    let profileName: String

    let lookUrl: URL

    let likes: Int

    let hashtag: String

    init?(builder: MiniLookFavoriteBuilder) throws {

        // Mandatory
        guard let id = builder.id  else {
            throw MiniLookError.MissingField("id")
        }
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

        self.id = id
        
        self.profileName = profileName

        self.profileUrl =  try profileUrl.asURL()

        self.lookUrl = try lookUrl.asURL()

        self.likes = likes
        
        self.hashtag = hashtag
    }
}
