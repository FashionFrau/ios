//
//  FavoriteLooksCollectionViewController.swift
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


class FavoriteLooksCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    fileprivate let favoriteLooksCollecitonViewControllerDomainError = "com.fashionfrau.favorites-collection-view-controller.error"

    fileprivate var dataSource: [FavoritesLooks] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        let nibHeader = UINib(nibName: nibForFavoriteLookHeader, bundle: nil)

        collectionView!.register(nibHeader, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: FavoriteLookHeaderReuseIdentifier)

        let nibFooter = UINib(nibName: nibForFavoriteLookFooter, bundle: nil)

        collectionView!.register(nibFooter, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: FavoriteLookFooterReuseIdentifier)


        collectionView!.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)

        if let layout = collectionView!.collectionViewLayout as? FavoriteLookLayout {

            layout.delegate = self
        }

        setupESPullToRefresh()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let destination = segue.destination as? LookDetailViewController {

            if let selectedLook = sender as? FavoriteLook {

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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteLookReuseIdentifier, for: indexPath) as! FavoriteLookCell

        let mini: FavoritesLooks? = dataSource[indexPath.section]

        if let miniLook = mini {

            let looks: [FavoriteLook]? = miniLook.looks

            if looks?.isEmpty == false && indexPath.row < looks!.count {

                let look = looks![indexPath.row]

                cell.model = look
            }
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if(kind == UICollectionElementKindSectionHeader) {

            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FavoriteLookHeaderReuseIdentifier, for: indexPath) as! FavoriteLookHeaderView

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
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FavoriteLookFooterReuseIdentifier, for: indexPath) as! FavoriteLookFooterView
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: LookDetailSegue, sender: dataSource[indexPath.section].looks[indexPath.row])
    }
}

extension FavoriteLooksCollectionViewController {

    fileprivate func loadData() {

        LookService.ls.get { (cards: [FavoritesLooks], errorResponse: ErrorResponse) in

            if self.isUnauthorized(response: errorResponse.response) {

                self.redirectToLogin()
            }
            
            self.collectionView!.es_stopPullToRefresh()

            self.dataSource = cards

            self.collectionView!.reloadData()

            if let error = errorResponse.error {

                Flurry.logError("\(self.favoriteLooksCollecitonViewControllerDomainError).load-favorites-data", message: error.localizedDescription, error: error)
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

extension FavoriteLooksCollectionViewController : FavoriteLookLayoutDelegate {

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
