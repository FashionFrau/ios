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

    var profileUrlString: String?

    var profileName: String?

    var lookUrlString: String?

    var likes: Int?

    var season: String?

    typealias BuilderClosure = (MiniLookHomeBuilder) -> ()

    init(buildClosure: BuilderClosure) {

        buildClosure(self)
    }

}

struct MiniLookHome {

    let profileUrl: URL

    let profileName: String

    let lookUrl: URL

    let likes: Int

    let season: String

    init?(builder: MiniLookHomeBuilder) throws {

        // Mandatory
        if let lookUrl = builder.lookUrlString, let profileName = builder.profileName, let profileUrl = builder.profileUrlString, let likes = builder.likes, let season = builder.season {

            self.profileName = profileName

            self.profileUrl =  try profileUrl.asURL()

            self.lookUrl = try lookUrl.asURL()

            self.likes = likes

            self.season = season

        } else {

            throw LookError.MissingField
        }
    }
}
