//
//  MiniLooksFavorite.swift
//  fashionfrau
//
//  Created by Nilson Junior on 17/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation
import SwiftDate


struct MiniLooksFavorite: ResponseObjectSerializable, ResponseCollectionSerializable {

    var date: DateInRegion?

    var looks: [MiniLookFavorite]

    init?(response: HTTPURLResponse, representation: Any) {

        guard
            let representation = representation as? [String: Any],

            let date = representation["date"] as? String,

            let looks = representation["looks"] as? [[String: Any]]

            else { return nil }

        var collection: [MiniLookFavorite] = []

        for look in looks {
            if let l = MiniLookFavorite(response: response, representation: look) {
                collection.append(l)
            }
        }

        self.looks = collection

        self.date = DateInRegion(string: date, format: .iso8601(options: .withFullDate))
    }
}
