//
//  MiniLooksFavorite.swift
//  fashionfrau
//
//  Created by Nilson Junior on 17/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation
import SwiftDate

class MiniLooksFavoriteBuilder {

    var date: String?

    var looks: [MiniLookFavoriteBuilder]?

    typealias BuilderClosure = (MiniLooksFavoriteBuilder) -> ()

    init(buildClosure: BuilderClosure) {

        buildClosure(self)
    }
}

struct MiniLooksFavorite {

    let date: DateInRegion

    let looks: [MiniLookFavorite]

    init?(builder: MiniLooksFavoriteBuilder) throws {

        // Mandatory

        if let dateString = builder.date, let looks = builder.looks {

            if let date = DateInRegion(string: dateString, format: .iso8601(options: .withFullDate)) {
                self.date = date
            } else {
                throw MiniLookCardError.ParseDate
            }

            var looksMiniCard: [MiniLookFavorite] = []

            for look in looks {

                let builder = try MiniLookFavorite(builder: look)

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
