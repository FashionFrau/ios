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

    func get(userId: String, user: ((User?, Error?) -> Void)!) {

        let url = try! "\(baseUrl)\(usersUrl)/\(userId)".asURL()

        var currentUser: User?

        Alamofire.request(url, headers: defaultHeaders).validate().responseObject { (response: DataResponse<UserDTO>) in
            if response.result.isFailure {
                user(currentUser, response.result.error)
            } else {
                let dto = response.result.value

                do {
                    let builder = UserBuilder {
                        $0.profileName = dto?.profileName

                        $0.profileUrlString = dto?.profileUrl
                    }

                    currentUser = try User(builder: builder)

                }  catch UserError.MissingField(let field) {
                    Flurry.logError(UserDomainError, message: "MissingField: \(field)", error: nil)
                } catch let error {
                    Flurry.logError("\(self.userServiceDomainError).cards", message: error.localizedDescription, error: error)
                }
                user(currentUser, nil)
            }
        }
    }
}
