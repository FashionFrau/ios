//
//  User.swift
//  fashionfrau
//
//  Created by Nilson Junior on 26.04.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation


class UserBuilder {

    var id: String?

    var profileName: String?

    var profileUrlString: String?

    var posts: Int?

    var liked: Int?

    var likes: Int?

    typealias BuilderClosure = (UserBuilder) -> ()

    init(buildClosure: BuilderClosure) {

        buildClosure(self)
    }

    static func map(dto: UserDTO) -> UserBuilder {
        return UserBuilder {
            $0.id = dto.id

            $0.profileName = dto.profileName

            $0.profileUrlString = dto.profileUrl

            $0.posts = dto.posts

            $0.liked = dto.liked

            $0.likes = dto.likes
        }
    }
}

struct User {

    let id: String

    let profileUrl: URL

    let profileName: String

    let posts: Int

    let liked: Int

    let likes: Int


    init?(builder: UserBuilder) throws {

        guard let id = builder.id  else {
            throw UserError.MissingField("id")
        }
        guard let profileName = builder.profileName else {
            throw UserError.MissingField("profileName")
        }
        guard let profileUrl = builder.profileUrlString else {
            throw UserError.MissingField("profileUrl")
        }
        guard let posts = builder.posts else {
            throw UserError.MissingField("posts")
        }
        guard let liked = builder.liked else {
            throw UserError.MissingField("liked")
        }
        guard let likes = builder.likes else {
            throw UserError.MissingField("likes")
        }

        self.id = id
        
        self.profileName = profileName

        self.profileUrl =  try profileUrl.asURL()

        self.posts = posts

        self.liked = liked

        self.likes = likes
    }
}
