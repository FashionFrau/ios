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

class CardService {

    static let cs = CardService()

    let cardsUrl = "/cards"

    let miniCardsUrl = "/mini-cards"

    let likedCardsUrl = "/liked"

    let keyPath = "cards"

    func get(cards: (([LookCard], NSError?) -> Void)!) {

        let url = try! "\(baseUrl)\(cardsUrl)".asURL()

        var looks: [LookCard] = []

        Alamofire.request(url, headers: defaultHeaders).validate().responseArray(keyPath: keyPath) { (response: DataResponse<[LookDTO]>) in

            let looksDTO = response.result.value

            let looksAsBuilder: [LookCardBuilder] = self.createLookCardBuilder(from: looksDTO)

            for lookAsBuilder in looksAsBuilder {

                do {

                    let look = try LookCard(builder: lookAsBuilder)

                    if let look = look {

                        looks.append(look)
                    }

                } catch  let error as NSError {

                    cards(looks, error)
                }
            }
            cards(looks, nil)
        }
    }

    func get(miniCards: (([MiniLooksFavorite], NSError?) -> Void)!) {

        let url = try! "\(baseUrl)\(miniCardsUrl)".asURL()

        var looks: [MiniLooksFavorite] = []

        Alamofire.request(url, headers: defaultHeaders).validate().responseArray(keyPath: keyPath) { (response: DataResponse<[MiniLookFavoriteDTO]>) in

            let miniLooksDTO = response.result.value

            let looksAsBuilder: [MiniLooksFavoriteBuilder] = self.createMiniLooksFavoriteBuilder(from: miniLooksDTO)

            for lookAsBuilder in looksAsBuilder {

                do {

                    let builded = try MiniLooksFavorite(builder: lookAsBuilder)

                    if let look = builded {

                        looks.append(look)
                    }

                } catch  let error as NSError {

                    miniCards(looks, error)
                }
            }
            miniCards(looks, nil)
        }
    }

    func get(likedCards: (([MiniLookHome], NSError?) -> Void)!) {

        let url = try! "\(baseUrl)\(miniCardsUrl)\(likedCardsUrl)".asURL()

        var looks: [MiniLookHome] = []

        Alamofire.request(url, headers: defaultHeaders).validate().responseArray(keyPath: keyPath) { (response: DataResponse<[LookDTO]>) in

            let looksDTO = response.result.value

            let looksAsBuilder: [MiniLookHomeBuilder] = self.createMiniLookHomeBuilder(from: looksDTO)

            for lookAsBuilder in looksAsBuilder {

                do {

                    let builded = try MiniLookHome(builder: lookAsBuilder)

                    if let look = builded {

                        looks.append(look)
                    }

                } catch  let error as NSError {
                    
                    likedCards(looks, error)
                }
            }
            likedCards(looks, nil)
        }
    }
}


extension  CardService {

    fileprivate func createLookCardBuilder(from looksDTO: [LookDTO]?) -> [LookCardBuilder] {

        var looksAsBuilder: [LookCardBuilder] = []

        if looksDTO?.isEmpty == false {

            for dto in looksDTO! {

                let builder = LookCardBuilder {

                    $0.profileName = dto.profileName

                    $0.profileUrlString = dto.profileUrlString

                    $0.lookUrlString = dto.lookUrlString

                    $0.gallery = dto.gallery
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
