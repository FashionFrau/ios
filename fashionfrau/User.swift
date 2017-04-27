//
//  User.swift
//  fashionfrau
//
//  Created by Nilson Junior on 26.04.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation


class UserBuilder {

    var profileName: String?

    var profileUrlString: String?

    typealias BuilderClosure = (UserBuilder) -> ()

    init(buildClosure: BuilderClosure) {

        buildClosure(self)
    }
}

struct User {
    let profileUrl: URL

    let profileName: String

    init?(builder: UserBuilder) throws {

        guard let profileName = builder.profileName else {
            throw UserError.MissingField("profileName")
        }
        guard let profileUrl = builder.profileUrlString else {
            throw UserError.MissingField("profileUrl")
        }

        self.profileName = profileName

        self.profileUrl =  try profileUrl.asURL()
    }
}
