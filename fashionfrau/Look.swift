//
//  Look.swift
//  fashionfrau
//
//  Created by Nilson Junior on 11/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation

class LookBuilder {

    var profileUrl: String?

    var profileName: String?

    var lookUrl: String?

    typealias BuilderClosure = (LookBuilder) -> ()


    init(buildClosure: BuilderClosure) {

        buildClosure(self)

    }
}

struct Look {

    var profileUrl: URL

    let profileName: String

    var lookUrl: URL


    init?(builder: LookBuilder) throws {

        if let lookUrl = builder.lookUrl, let profileName = builder.profileName, let profileUrl = builder.profileUrl {

            self.profileName = profileName

            if let urlLook = URL(string: lookUrl), let urlProfile = URL(string: profileUrl) {

                self.lookUrl = urlLook

                self.profileUrl = urlProfile

            } else {
                
                throw LookError.BadUrl
                
            }
            
        } else {
            
            throw LookError.MissingField
            
        }
    }
}
