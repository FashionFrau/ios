//
//  MiniLookFavorite.swift
//  fashionfrau
//
//  Created by Nilson Junior on 16/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation

struct FavoriteLook: ResponseObjectSerializable, ResponseCollectionSerializable {

    var id: String

    var profileUrl: String

    var profileName: String

    var lookUrl: String

    var likes: Int

//    var hashtag: String


    init?(response: HTTPURLResponse, representation: Any) {

        guard
            let representation = representation as? [String: Any],

            let id = representation["id"] as? String,

            let profileUrl = representation["profileUrl"] as? String,

            let profileName = representation["profileName"] as? String,

            let lookUrl = representation["lookUrl"] as? String,

            let likes = representation["likes"] as? Int

//            let hashtag = representation["hashtag"] as? String

            else { return nil }

        self.id = id
        
        self.profileName = profileName

        self.profileUrl = profileUrl

        self.lookUrl = lookUrl

        self.likes = likes
        
//        self.hashtag = hashtag
    }
}
