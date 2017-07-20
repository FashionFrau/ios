//
//  User.swift
//  fashionfrau
//
//  Created by Nilson Junior on 26.04.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation

struct User: ResponseObjectSerializable, NSObject, NSCoding {

    var uid: String

    var profilePicture: String

    var username: String

    var authToken: String

    var posts: Int

    var liked: Int

    var likes: Int

    var askUserFollow: Bool = true

    var askUserFeedback: Bool = false

    init?(response: HTTPURLResponse, representation: Any) {

        guard
            let representation = representation as? [String: Any],

            let uid = representation["uid"] as? String,

            let profilePicture = representation["profile_picture"] as? String,

            let username = representation["username"] as? String,

            let authToken = representation["auth_token"] as? String,

            let posts = representation["posts"] as? Int,

            let liked = representation["liked"] as? Int,

            let likes = representation["likes"] as? Int

            else { return nil }


        self.uid = uid

        self.username = username

        self.profilePicture = profilePicture

        self.authToken = authToken

        self.posts = posts

        self.liked = liked

        self.likes = likes

        if let askUserFollow = representation["ask_user_follow"] as? Bool {

            self.askUserFollow = askUserFollow
        }

        if let askUserFeedback = representation["ask_user_feedback"] as? Bool {

            self.askUserFeedback = askUserFeedback
        }
    }

    init?(representation: Any?) {

        guard
            let representation = representation as? [String: Any],

            let uid = representation["uid"] as? String,

            let profilePicture = representation["profile_picture"] as? String,

            let username = representation["username"] as? String,

            let authToken = representation["auth_token"] as? String,

            let posts = representation["posts"] as? Int,

            let liked = representation["liked"] as? Int,

            let likes = representation["likes"] as? Int

            else { return nil }


        self.uid = uid

        self.username = username

        self.profilePicture = profilePicture

        self.authToken = authToken

        self.posts = posts

        self.liked = liked

        self.likes = likes


        if let askUserFollow = representation["ask_user_follow"] as? Bool {

            self.askUserFollow = askUserFollow
        }
        
        if let askUserFeedback = representation["ask_user_feedback"] as? Bool {
            
            self.askUserFeedback = askUserFeedback
        }
    }

    //    MARK: - NSCoding Protocol

    required init?(coder aDecoder: NSCoder) {
        self.uid = aDecoder.decodeObject(forKey: "uid") as! String

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
