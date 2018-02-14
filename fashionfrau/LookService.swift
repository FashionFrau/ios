//
//  LookService.swift
//  fashionfrau
//
//  Created by Nilson Junior on 16/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire
import Flurry_iOS_SDK

class LookService {

    class var ls : LookService {
        struct Static {
            static let instance: LookService = LookService()
        }
        return Static.instance
    }

    private let lookServiceDomainError = "com.fashionfrau.look-service.error"

    private let looksUrl = "/api/looks"

    private let likedLooksUrl = "/api/liked"

    private let favoritesLooksUrl = "/api/favorites"


    func get(lookId: String, success: ((Look) -> Void)!, failure: ((ErrorResponse) -> Void)!) {

        let url = try! "\(baseUrl)\(looksUrl)/\(lookId)".asURL()

        self.setAuthHeader()

        Alamofire.request(url, headers: defaultHeaders).validate().responseObject { (response: DataResponse<Look>) in

            if let look = response.result.value {

                success(look)

            } else {

                failure(ErrorResponse(response: response.response, error: response.error))
            }
        }
    }

    func get(looks: (([Look], ErrorResponse) -> Void)!) {

        let url = try! "\(baseUrl)\(looksUrl)".asURL()

        self.setAuthHeader()

        Alamofire.request(url, headers: defaultHeaders).validate().responseCollection { (response: DataResponse<[Look]>) in

            if let result = response.result.value {

                looks(result, ErrorResponse(response: response.response, error: response.error))

            } else {

                looks([], ErrorResponse(response: response.response, error: response.error))
            }
        }
    }

    func get(favoriteLooks: (([FavoritesLooks], ErrorResponse) -> Void)!) {

        let url = try! "\(baseUrl)\(favoritesLooksUrl)".asURL()

        self.setAuthHeader()

        Alamofire.request(url, headers: defaultHeaders).validate().responseCollection { (response: DataResponse<[FavoritesLooks]>) in

            if let looks = response.result.value {

                favoriteLooks(looks, ErrorResponse(response: response.response, error: response.error))

            } else {

                favoriteLooks([], ErrorResponse(response: response.response, error: response.error))
            }
        }
    }

    func get(likedLooks: (([LikedLook], ErrorResponse) -> Void)!) {

        let url = try! "\(baseUrl)\(likedLooksUrl)".asURL()

        self.setAuthHeader()

        Alamofire.request(url, headers: defaultHeaders).validate().responseCollection { (response: DataResponse<[LikedLook]>) in

            if let looks = response.result.value {

                likedLooks(looks, ErrorResponse(response: response.response, error: response.error))

            } else {

                likedLooks([], ErrorResponse(response: response.response, error: response.error))
            }
        }
    }

    func like(lookId: String, success: ((HTTPURLResponse?) -> Void)!, failure: ((ErrorResponse) -> Void)!) {

        let url = try! "\(baseUrl)\(looksUrl)/\(lookId)/like".asURL()

        let parameters: Parameters = [:]

        self.setAuthHeader()

        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: defaultHeaders).validate().response { (response: DefaultDataResponse) in

            if let error = response.error {

                failure(ErrorResponse(response: response.response, error: response.error))

                Flurry.logError("\(self.lookServiceDomainError).like", message: error.localizedDescription, error: error)
            } else {

                success(response.response)
            }
        }
    }

    func unlike(lookId: String, success: ((HTTPURLResponse?) -> Void)!, failure: ((ErrorResponse) -> Void)!) {

        let url = try! "\(baseUrl)\(looksUrl)/\(lookId)/unlike".asURL()

        let parameters: Parameters = [:]

        self.setAuthHeader()

        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: defaultHeaders).validate().response { (response: DefaultDataResponse) in

            if let error = response.error {

                failure(ErrorResponse(response: response.response, error: response.error))

                Flurry.logError("\(self.lookServiceDomainError).like", message: error.localizedDescription, error: error)
            } else {

                success(response.response)
            }
        }
    }
    
    func setAuthHeader() {

        guard let _ = defaultHeaders["Authorization"] else {

            do {
                let user = try UserService.us.getCurrentUser()

                defaultHeaders["Authorization"] = "Bearer \(user.authToken!)"
            } catch let error {

                Flurry.logError("\(self.lookServiceDomainError).set-auth-header", message: error.localizedDescription, error: error)
            }
            return
        }
    }
}
