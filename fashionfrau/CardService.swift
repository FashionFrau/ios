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

    static let cs = CardService()

    private let cardServiceDomainError = "com.fashionfrau.card-service.error"

    private let cardsUrl = "/cards"

    private let miniCardsUrl = "/mini-cards"

    private let likedCardsUrl = "/liked"

    func get(cardId: String, success: ((Look) -> Void)!, failure: ((Error?) -> Void)!) {

        let url = try! "\(baseUrl)\(cardsUrl)/\(cardId)".asURL()

        Alamofire.request(url, headers: defaultHeaders).validate().responseObject { (response: DataResponse<Look>) in

            if let look = response.result.value {

                success(look)

            } else {

                failure(response.result.error)
            }
        }
    }

    func get(cards: (([Look], Error?) -> Void)!) {

        let url = try! "\(baseUrl)\(cardsUrl)".asURL()

        Alamofire.request(url, headers: defaultHeaders).validate().responseCollection { (response: DataResponse<[Look]>) in

            if let looks = response.result.value {

                cards(looks, nil)

            } else {

                cards([], response.result.error)
            }
        }
    }

    func get(favoriteCards: (([MiniLooksFavorite], Error?) -> Void)!) {

        let url = try! "\(baseUrl)\(miniCardsUrl)".asURL()

        Alamofire.request(url, headers: defaultHeaders).validate().responseCollection { (response: DataResponse<[MiniLooksFavorite]>) in

            if let looks = response.result.value {

                favoriteCards(looks, nil)

            } else {

                favoriteCards([], response.result.error)
            }
        }
    }

    func get(likedCards: (([MiniLookHome], Error?) -> Void)!) {

        let url = try! "\(baseUrl)\(miniCardsUrl)\(likedCardsUrl)".asURL()
        
        Alamofire.request(url, headers: defaultHeaders).validate().responseCollection { (response: DataResponse<[MiniLookHome]>) in
            
            if let looks = response.result.value {
                
                likedCards(looks, nil)
                
            } else {
                
                likedCards([], response.result.error)
            }
        }
    }
}
