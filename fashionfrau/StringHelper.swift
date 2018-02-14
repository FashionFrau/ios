//
//  StringHelper.swift
//  fashionfrau
//
//  Created by Nilson Junior on 17/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation

extension String {

    func cut(at index: Int) -> String {

        if index >= self.count {
            return self
        }

        let start = self.startIndex

        let end = self.index(start, offsetBy: index)

        return self[start...end]
    }
}
