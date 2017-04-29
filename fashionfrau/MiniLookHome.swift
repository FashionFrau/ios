//
//  MiniLookHome.swift
//  fashionfrau
//
//  Created by Nilson Junior on 24.04.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation
import UIKit

class MiniLookHomeBuilder {

    var id: String?

    var profileUrlString: String?

    var profileName: String?

    var lookUrlString: String?

    var likes: Int?

    var season: String?

    typealias BuilderClosure = (MiniLookHomeBuilder) -> ()

    init(buildClosure: BuilderClosure) {

        buildClosure(self)
    }

    static func map(dto: LookDTO) -> MiniLookHomeBuilder {
        return MiniLookHomeBuilder {

            $0.id = dto.id

            $0.profileName = dto.profileName

            $0.profileUrlString = dto.profileUrlString

            $0.lookUrlString = dto.lookUrlString

            $0.likes = dto.likes

            $0.season = dto.season
        }
    }
}

struct MiniLookHome {

    let id: String

    let profileUrl: URL

    let profileName: String

    let lookUrl: URL

    let likes: Int

    let season: String

    init?(builder: MiniLookHomeBuilder) throws {

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

        guard let season = builder.season else {
            throw MiniLookError.MissingField("season")
        }

        self.id = id
        
        self.profileName = profileName
        
        self.profileUrl =  try profileUrl.asURL()
        
        self.lookUrl = try lookUrl.asURL()
        
        self.likes = likes
        
        self.season = season
        
    }
}
