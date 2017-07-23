//
//  FavoritesCollectionViewController.swift
//  fashionfrau
//
//  Created by Nilson Junior on 15/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import Alamofire
import SwiftDate
import Device
import Flurry_iOS_SDK
import ESPullToRefresh

private let miniCardFavoriteReuseIdentifier = "MiniCardFavoriteCell"
private let miniCardFavoriteHeaderReuseIdentifier = "MiniCardFavoriteHeaderCell"
private let miniCardFavoriteFooterReuseIdentifier = "MiniCardFavoriteFooterCell"

private let miniCardDetailSegue =  "CardDetailViewController"

class FavoritesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let nibForFavoriteHeader = "MiniCardFavoriteHeaderView"
    private let nibForFavoriteFooter = "MiniCardFavoriteFooterView"

    fileprivate let favoritesCollecitonViewControllerDomainError = "com.fashionfrau.favorites-collection-view-controller.error"

    fileprivate var dataSource: [MiniLooksFavorite] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        let nibHeader = UINib(nibName: nibForFavoriteHeader, bundle: nil)

        collectionView!.register(nibHeader, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: miniCardFavoriteHeaderReuseIdentifier)

        let nibFooter = UINib(nibName: nibForFavoriteFooter, bundle: nil)

        collectionView!.register(nibFooter, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: miniCardFavoriteFooterReuseIdentifier)


        collectionView!.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)

        if let layout = collectionView!.collectionViewLayout as? MiniCardsFavoriteLayout {

            layout.delegate = self
        }

        setupESPullToRefresh()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let destination = segue.destination as? CardDetailViewController {

            if let selectedLook = sender as? MiniLookFavorite {

                destination.lookId = selectedLook.id
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].looks.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: miniCardFavoriteReuseIdentifier, for: indexPath) as! MiniCardFavoriteCell

        let mini: MiniLooksFavorite? = dataSource[indexPath.section]

        if let miniLook = mini {

            let looks: [MiniLookFavorite]? = miniLook.looks

            if looks?.isEmpty == false && indexPath.row < looks!.count {

                let look = looks![indexPath.row]

                cell.model = look
            }
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if(kind == UICollectionElementKindSectionHeader) {

            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: miniCardFavoriteHeaderReuseIdentifier, for: indexPath) as! MiniCardFavoriteHeaderView

            let date: DateInRegion? = dataSource[indexPath.section].date

            if let date = date {

                header.model = date


//                let tapHeader = createTagGestureHeader()
//
//                header.tag = indexPath.section
//                header.isUserInteractionEnabled = true
//
//                header.addGestureRecognizer(tapHeader)
            }

            return header
        } else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: miniCardFavoriteFooterReuseIdentifier, for: indexPath) as! MiniCardFavoriteFooterView
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: miniCardDetailSegue, sender: dataSource[indexPath.section].looks[indexPath.row])
    }
}

extension FavoritesCollectionViewController {

    fileprivate func loadData() {

        CardService.cs.get { (cards: [MiniLooksFavorite], errorResponse: ErrorResponse) in

            if self.isUnauthorized(response: errorResponse.response) {

                self.redirectToLogin()
            }
            
            self.collectionView!.es_stopPullToRefresh()

            self.dataSource = cards

            self.collectionView!.reloadData()

            if let error = errorResponse.error {

                Flurry.logError("\(self.favoritesCollecitonViewControllerDomainError).fake-data", message: error.localizedDescription, error: error)
            }
        }
    }

    fileprivate func setupESPullToRefresh() {
        collectionView!.alwaysBounceVertical = true

        collectionView!.es_addPullToRefresh {
            self.loadData()
        }

        collectionView!.es_startPullToRefresh()
    }

//    fileprivate func createTagGestureHeader() -> UITapGestureRecognizer {
//        let action = #selector(openHeaderOnDate(sender:))
//        let tapGesture = UITapGestureRecognizer(target: self, action: action)
//
//        tapGesture.delegate = self as? UIGestureRecognizerDelegate
//        tapGesture.numberOfTapsRequired = 1
//
//        return tapGesture
//    }

//    func openHeaderOnDate(sender: UITapGestureRecognizer) {
        //        let section = sender.view?.tag

        //        if let section = section {
        //            TODO
        //            print(dataSource[section].date)
        //        }
//    }
}

extension FavoritesCollectionViewController : MiniCardsLayoutDelegate {

    func collectionView(collectionView:UICollectionView, heightForMiniCardWithWidth:CGFloat) -> CGFloat {

        switch Device.size() {
        case .screen3_5Inch:  return 115
        case .screen4Inch:    return 200
        case .screen4_7Inch:  return 200
        case .screen5_5Inch:  return 250
        case .screen7_9Inch:  return 400
        case .screen9_7Inch:  return 750
        default:              return 200
        }
    }
    
    func collectionViewFooterHeight() -> CGFloat {
        return 25.0
    }
    
    func collectionViewHeaderWidthPercentage() -> CGFloat {
        return 0.10
    }
    
    func collectionViewMiniCardInset() -> UIEdgeInsets {
        return UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    }
}
