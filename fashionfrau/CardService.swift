//
//  Cards.swift
//  fashionfrau
//
//  Created by Nilson Junior on 16/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire
import Flurry_iOS_SDK

class CardService {

    class var cs : CardService {
        struct Static {
            static let instance: CardService = CardService()
        }
        return Static.instance
    }

    private let cardServiceDomainError = "com.fashionfrau.card-service.error"

    private let cardsUrl = "/api/cards"

    private let miniCardsUrl = "/api/mini-cards"

    private let likedCardsUrl = "/liked"

    func get(cardId: String, success: ((Look) -> Void)!, failure: ((ErrorResponse) -> Void)!) {

        let url = try! "\(baseUrl)\(cardsUrl)/\(cardId)".asURL()

        self.setAuthHeader()

        Alamofire.request(url, headers: defaultHeaders).validate().responseObject { (response: DataResponse<Look>) in

            if let look = response.result.value {

                success(look)

            } else {

                failure(ErrorResponse(response: response.response, error: response.error))
            }
        }
    }

    func get(cards: (([Look], ErrorResponse) -> Void)!) {

        let url = try! "\(baseUrl)\(cardsUrl)".asURL()

        self.setAuthHeader()

        Alamofire.request(url, headers: defaultHeaders).validate().responseCollection { (response: DataResponse<[Look]>) in

            if let looks = response.result.value {

                cards(looks, ErrorResponse(response: response.response, error: response.error))

            } else {

                cards([], ErrorResponse(response: response.response, error: response.error))
            }
        }
    }

    func get(favoriteCards: (([MiniLooksFavorite], ErrorResponse) -> Void)!) {

        let url = try! "\(baseUrl)\(miniCardsUrl)".asURL()

        self.setAuthHeader()

        Alamofire.request(url, headers: defaultHeaders).validate().responseCollection { (response: DataResponse<[MiniLooksFavorite]>) in

            if let looks = response.result.value {

                favoriteCards(looks, ErrorResponse(response: response.response, error: response.error))

            } else {

                favoriteCards([], ErrorResponse(response: response.response, error: response.error))
            }
        }
    }

    func get(likedCards: (([MiniLookHome], ErrorResponse) -> Void)!) {

        let url = try! "\(baseUrl)\(miniCardsUrl)\(likedCardsUrl)".asURL()

        self.setAuthHeader()

        Alamofire.request(url, headers: defaultHeaders).validate().responseCollection { (response: DataResponse<[MiniLookHome]>) in

            if let looks = response.result.value {

                likedCards(looks, ErrorResponse(response: response.response, error: response.error))

            } else {

                likedCards([], ErrorResponse(response: response.response, error: response.error))
            }
        }
    }

    func like(cardId: String, success: ((HTTPURLResponse?) -> Void)!, failure: ((ErrorResponse) -> Void)!) {

        let url = try! "\(baseUrl)\(cardsUrl)/\(cardId)/like".asURL()

        let parameters: Parameters = [:]

        self.setAuthHeader()

        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: defaultHeaders).validate().response { (response: DefaultDataResponse) in

            if let error = response.error {

                failure(ErrorResponse(response: response.response, error: response.error))

                Flurry.logError("\(self.cardServiceDomainError).like", message: error.localizedDescription, error: error)
            } else {

                success(response.response)
            }
        }
    }

    func unlike(cardId: String, success: ((HTTPURLResponse?) -> Void)!, failure: ((ErrorResponse) -> Void)!) {

        let url = try! "\(baseUrl)\(cardsUrl)/\(cardId)/unlike".asURL()

        let parameters: Parameters = [:]

        self.setAuthHeader()

        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: defaultHeaders).validate().response { (response: DefaultDataResponse) in

            if let error = response.error {

                failure(ErrorResponse(response: response.response, error: response.error))

                Flurry.logError("\(self.cardServiceDomainError).like", message: error.localizedDescription, error: error)
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

                Flurry.logError("\(self.cardServiceDomainError).set-auth-header", message: error.localizedDescription, error: error)
            }
            return
        }
    }
}
