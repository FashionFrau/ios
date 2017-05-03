//
//  User.swift
//  fashionfrau
//
//  Created by Nilson Junior on 26.04.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation

struct User: ResponseObjectSerializable {

    var id: String

    var profileUrl: String

    var profileName: String

    var posts: Int

    var liked: Int

    var likes: Int

    init?(response: HTTPURLResponse, representation: Any) {

        guard
            let representation = representation as? [String: Any],

            let id = representation["id"] as? String,

            let profileUrl = representation["profileUrl"] as? String,

            let profileName = representation["profileName"] as? String,

            let posts = representation["posts"] as? Int,

            let liked = representation["liked"] as? Int,

            let likes = representation["likes"] as? Int

        else { return nil }


        self.id = id

        self.profileName = profileName

        self.profileUrl =  profileUrl

        self.posts = posts

        self.liked = liked

        self.likes = likes
    }
}
