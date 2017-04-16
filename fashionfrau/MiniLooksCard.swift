//
//  MiniLooksCard.swift
//  fashionfrau
//
//  Created by Nilson Junior on 17/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation
import SwiftDate

class MiniLooksCardBuilder {

    var date: String?

    var looks: [MiniLookCardBuilder]?

    typealias BuilderClosure = (MiniLooksCardBuilder) -> ()

    init(buildClosure: BuilderClosure) {

        buildClosure(self)
    }
}

struct MiniLooksCard {

    let date: DateInRegion

    let looks: [MiniLookCard]

    init?(builder: MiniLooksCardBuilder) throws {

        // Mandatory

        if let dateString = builder.date, let looks = builder.looks {

            if let date = DateInRegion(string: dateString, format: .iso8601(options: .withFullDate)) {
                self.date = date
            } else {
                throw MiniLookCardError.ParseDate
            }

            var looksMiniCard: [MiniLookCard] = []

            for look in looks {

                let builder = try MiniLookCard(builder: look)

                if let builded = builder {

                    looksMiniCard.append(builded)
                }
            }

            self.looks = looksMiniCard
            
        } else {
            
            throw MiniLookCardError.MissingField
        }
    }
}
