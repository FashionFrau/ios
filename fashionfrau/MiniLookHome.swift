//
//  MiniLookHome.swift
//  fashionfrau
//
//  Created by Nilson Junior on 24.04.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation

struct MiniLookHome: ResponseObjectSerializable, ResponseCollectionSerializable {

    var id: String

    var profileUrl: String

    var profileName: String

    var lookUrl: String

    var likes: Int

//    var season: String

    init?(response: HTTPURLResponse, representation: Any) {

        guard
            let representation = representation as? [String: Any],

            let id = representation["id"] as? String,

            let profileUrl = representation["profileUrl"] as? String,

            let profileName = representation["profileName"] as? String,

            let lookUrl = representation["lookUrl"] as? String,

            let likes = representation["likes"] as? Int

//            let season = representation["season"] as? String


        else { return nil }

        self.id = id
        
        self.profileName = profileName
        
        self.profileUrl = profileUrl
        
        self.lookUrl = lookUrl
        
        self.likes = likes
        
//        self.season = season
    }
}
