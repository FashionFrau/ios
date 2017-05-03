//
//  UserService.swift
//  fashionfrau
//
//  Created by Nilson Junior on 26.04.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire
import Flurry_iOS_SDK


class UserService {

    static let us = UserService()

    private let userServiceDomainError = "user-service"

    private let usersUrl = "/users"

    func get(userId: String, success: ((User) -> Void)!, failure: ((Error?) -> Void)!) {

        let url = try! "\(baseUrl)\(usersUrl)/\(userId)".asURL()

        Alamofire.request(url, headers: defaultHeaders).validate().responseObject { (response: DataResponse<User>) in

            if let currentUser = response.result.value {

                success(currentUser)

            } else {

                failure(response.result.error)
            }
        }
    }
}
