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

enum UserError: Error {
    case NotFound
    case NotSaved
}
class UserService {

    private let UserKey = "UserKey"

    fileprivate let userServiceDomainError = "com.fashionfrau.user-service.error"

    static let us = UserService()

    private let usersUrl = "/users"

    func getCurrentUser() throws -> CurrentUser {

        if let data = UserDefaults.standard.object(forKey: UserKey) as? NSData {

            if let user = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? CurrentUser {

                return user
            }
        }

        throw UserError.NotFound
    }

    func saveCurrentUser(user: User) throws {

        let currentUser = CurrentUser()

        currentUser.uid = user.uid
        currentUser.profilePicture = user.profilePicture
        currentUser.username = user.username
        currentUser.authToken = user.authToken
        currentUser.posts = user.posts
        currentUser.liked = user.liked
        currentUser.likes = user.likes
        currentUser.askUserFollow = user.askUserFollow
        currentUser.askUserFeedback = user.askUserFeedback

        let ud = UserDefaults.standard

        ud.setValue(NSKeyedArchiver.archivedData(withRootObject: currentUser), forKey: UserKey)

        if !ud.synchronize() {

            throw UserError.NotSaved
        }
    }

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

    func askUserFollow() {

        let url = try! "\(baseUrl)\(usersUrl)/follow-us".asURL()

        let parameters: Parameters = [:]

        Alamofire.request(url, method: HTTPMethod.post, parameters: parameters, encoding: URLEncoding.default, headers: defaultHeaders).validate().response { (response: DefaultDataResponse) in

            if let error = response.error {

                Flurry.logError("\(self.userServiceDomainError).ask-user-follow", message: error.localizedDescription, error: error)
            }
            
        }
    }
}
