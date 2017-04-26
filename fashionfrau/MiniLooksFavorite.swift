//
//  MiniLooksFavorite.swift
//  fashionfrau
//
//  Created by Nilson Junior on 17/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation
import SwiftDate
import Flurry_iOS_SDK

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
        guard let looks = builder.looks else {
            throw MiniLookError.MissingField("looks")
        }

        var looksMiniCard: [MiniLookFavorite] = []

        for look in looks {


            let builder = try MiniLookFavorite(builder: look)

            if let builded = builder {

                looksMiniCard.append(builded)
            }
        }

        self.looks = looksMiniCard

        guard let dateString = builder.date else {
            throw MiniLookError.MissingField("date")
        }

        if let date = DateInRegion(string: dateString, format: .iso8601(options: .withFullDate)) {
            self.date = date
        } else {
            throw MiniLookError.ParseDate
        }
    }
}
