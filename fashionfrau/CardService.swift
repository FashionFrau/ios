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

    private let cardServiceDomainError = "card-service"

    private let cardsUrl = "/cards"

    private let miniCardsUrl = "/mini-cards"

    private let likedCardsUrl = "/liked"

    private let keyPath = "cards"

    func get(cards: (([LookCard], Error?) -> Void)!) {

        let url = try! "\(baseUrl)\(cardsUrl)".asURL()

        var looks: [LookCard] = []

        Alamofire.request(url, headers: defaultHeaders).validate().responseArray(keyPath: keyPath) { (response: DataResponse<[LookDTO]>) in

            if response.result.isFailure {
                cards(looks, response.result.error)
            } else {

                let looksDTO = response.result.value

                let looksAsBuilder: [LookCardBuilder] = self.createLookCardBuilder(from: looksDTO)

                for lookAsBuilder in looksAsBuilder {

                    do {

                        let look = try LookCard(builder: lookAsBuilder)

                        if let look = look {

                            looks.append(look)
                        }

                    } catch LookError.MissingField(let field) {
                        Flurry.logError(LookDomainError, message: "MissingField: \(field)", error: nil)
                    } catch let error {
                        Flurry.logError("\(self.cardServiceDomainError).cards", message: error.localizedDescription, error: error)
                    }
                }
                cards(looks, nil)
            }
        }
    }

    func get(favoriteCards: (([MiniLooksFavorite], Error?) -> Void)!) {

        let url = try! "\(baseUrl)\(miniCardsUrl)".asURL()

        var looks: [MiniLooksFavorite] = []

        Alamofire.request(url, headers: defaultHeaders).validate().responseArray(keyPath: keyPath) { (response: DataResponse<[MiniLookFavoriteDTO]>) in

            if response.result.isFailure {
                favoriteCards(looks, response.result.error)
            } else {

                let miniLooksDTO = response.result.value

                let looksAsBuilder: [MiniLooksFavoriteBuilder] = self.createMiniLooksFavoriteBuilder(from: miniLooksDTO)

                for lookAsBuilder in looksAsBuilder {

                    do {

                        let builded = try MiniLooksFavorite(builder: lookAsBuilder)

                        if let look = builded {

                            looks.append(look)
                        }

                    } catch MiniLookError.MissingField(let field) {
                        Flurry.logError(MiniLookDomainError, message: "MissingField: \(field)", error: nil)
                    } catch let error {
                        Flurry.logError("\(self.cardServiceDomainError).miniCards", message: error.localizedDescription, error: error)
                    }
                }
                favoriteCards(looks, nil)
            }
        }
    }

    func get(likedCards: (([MiniLookHome], Error?) -> Void)!) {

        let url = try! "\(baseUrl)\(miniCardsUrl)\(likedCardsUrl)".asURL()

        var looks: [MiniLookHome] = []

        Alamofire.request(url, headers: defaultHeaders).validate().responseArray(keyPath: keyPath) { (response: DataResponse<[LookDTO]>) in

            if response.result.isFailure {
                likedCards(looks, response.result.error)
            } else {

                let looksDTO = response.result.value

                let looksAsBuilder: [MiniLookHomeBuilder] = self.createMiniLookHomeBuilder(from: looksDTO)

                for lookAsBuilder in looksAsBuilder {

                    do {
                        let builded = try MiniLookHome(builder: lookAsBuilder)

                        if let look = builded {

                            looks.append(look)
                        }

                    } catch MiniLookError.MissingField(let field) {
                        Flurry.logError(MiniLookDomainError, message: "MissingField: \(field)", error: nil)
                    } catch let error {
                        Flurry.logError("\(self.cardServiceDomainError).likedCards", message: error.localizedDescription, error: error)
                    }
                }
                likedCards(looks, nil)
            }
        }
    }
}


extension  CardService {

    fileprivate func createLookCardBuilder(from looksDTO: [LookDTO]?) -> [LookCardBuilder] {

        var looksAsBuilder: [LookCardBuilder] = []

        if looksDTO?.isEmpty == false {

            for dto in looksDTO! {

                let builder = LookCardBuilder {

                    $0.id = dto.id

                    $0.profileName = dto.profileName

                    $0.profileUrlString = dto.profileUrlString

                    $0.lookUrlString = dto.lookUrlString

                    $0.gallery = dto.gallery

                    $0.description = dto.description
                }

                looksAsBuilder.append(builder)
            }
        }

        return looksAsBuilder
    }

    fileprivate func createMiniLooksFavoriteBuilder(from miniLooksDTO: [MiniLookFavoriteDTO]?) -> [MiniLooksFavoriteBuilder] {

        var looksAsBuilder: [MiniLooksFavoriteBuilder] = []

        if miniLooksDTO?.isEmpty == false {

            for dto in miniLooksDTO! {

                let builder = MiniLooksFavoriteBuilder {

                    $0.date = dto.date

                    $0.looks = self.createMiniLookFavoriteBuilder(from: dto.looks)
                }

                looksAsBuilder.append(builder)
            }
        }

        return looksAsBuilder
    }

    fileprivate func createMiniLookFavoriteBuilder(from looksDTO: [LookDTO]?) -> [MiniLookFavoriteBuilder] {

        var looksAsBuilder: [MiniLookFavoriteBuilder] = []

        if looksDTO?.isEmpty == false {

            for dto in looksDTO! {

                let builder = MiniLookFavoriteBuilder {

                    $0.id = dto.id

                    $0.profileName = dto.profileName

                    $0.profileUrlString = dto.profileUrlString

                    $0.lookUrlString = dto.lookUrlString

                    $0.likes = dto.likes
                    
                    $0.hashtag = dto.hashtag
                }
                
                looksAsBuilder.append(builder)
            }
        }
        
        return looksAsBuilder
    }
    
    fileprivate func createMiniLookHomeBuilder(from looksDTO: [LookDTO]?) -> [MiniLookHomeBuilder] {
        
        var miniLookHomeAsBuilder: [MiniLookHomeBuilder] = []
        
        if looksDTO?.isEmpty == false {
            
            for dto in looksDTO! {
                
                let builder = MiniLookHomeBuilder {

                    $0.id = dto.id
                    
                    $0.profileName = dto.profileName
                    
                    $0.profileUrlString = dto.profileUrlString
                    
                    $0.lookUrlString = dto.lookUrlString
                    
                    $0.likes = dto.likes
                    
                    $0.season = dto.season
                }
                
                miniLookHomeAsBuilder.append(builder)
            }
        }
        
        return miniLookHomeAsBuilder
    }
}
