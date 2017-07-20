//
//  CurrentUser.swift
//  fashionfrau
//
//  Created by Nilson Junior on 20.07.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation

class CurrentUser: NSObject, NSCoding {

    var uid: String?

    var profilePicture: String?

    var username: String?

    var authToken: String?

    var posts: Int?

    var liked: Int?

    var likes: Int?

    var askUserFollow: Bool = true

    var askUserFeedback: Bool = false

    //    MARK: - NSCoding Protocol

    override init() {}

    required init(coder aDecoder: NSCoder) {

        uid = aDecoder.decodeObject(forKey: "uid") as? String
        profilePicture = aDecoder.decodeObject(forKey: "profilePicture") as? String
        username = aDecoder.decodeObject(forKey: "username") as? String
        authToken = aDecoder.decodeObject(forKey: "authToken") as? String
        posts = aDecoder.decodeObject(forKey: "posts") as? Int
        liked = aDecoder.decodeObject(forKey: "liked") as? Int
        likes = aDecoder.decodeObject(forKey: "likes") as? Int
        askUserFollow = aDecoder.decodeBool(forKey: "askUserFollow")
        askUserFeedback = aDecoder.decodeBool(forKey: "askUserFeedback")
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(profilePicture, forKey: "profilePicture")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(authToken, forKey: "authToken")
        aCoder.encode(posts, forKey: "posts")
        aCoder.encode(liked, forKey: "liked")
        aCoder.encode(likes, forKey: "likes")
        aCoder.encode(askUserFollow, forKey: "askUserFollow")
        aCoder.encode(askUserFeedback, forKey: "askUserFeedback")
    }
}
