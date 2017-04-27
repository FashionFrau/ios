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

private let miniCardFavoriteReuseIdentifier = "MiniCardFavoriteCell"
private let miniCardFavoriteHeaderReuseIdentifier = "MiniCardFavoriteHeaderCell"
private let miniCardFavoriteFooterReuseIdentifier = "MiniCardFavoriteFooterCell"

private let nibForFavoriteHeader = "MiniCardFavoriteHeaderView"
private let nibForFavoriteFooter = "MiniCardFavoriteFooterView"

class FavoritesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    fileprivate var dataSource: [MiniLooksFavorite] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        let nibHeader = UINib(nibName: nibForFavoriteHeader, bundle: nil)
        self.collectionView!.register(nibHeader, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: miniCardFavoriteHeaderReuseIdentifier)

        let nibFooter = UINib(nibName: nibForFavoriteFooter, bundle: nil)
        self.collectionView!.register(nibFooter, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: miniCardFavoriteFooterReuseIdentifier)


        collectionView?.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        if let layout = collectionView?.collectionViewLayout as? MiniCardsFavoriteLayout {
            layout.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fakeData()
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

                header.dateLabel.text = "\(date.day)"

                header.dayLabel.text = date.weekdayName.cut(at: 2)
            }

            return header
        } else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: miniCardFavoriteFooterReuseIdentifier, for: indexPath) as! MiniCardFavoriteFooterView
        }
    }
}

extension FavoritesCollectionViewController {
    fileprivate func fakeData() {
        CardService.cs.get(favoriteCards: { (cards: [MiniLooksFavorite], error: Error?) in
            if error == nil {
                self.dataSource = cards
                self.collectionView?.reloadData()
            }
        })
    }
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
