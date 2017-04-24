//
//  FavoritesCollectionViewController.swift
//  fashionfrau
//
//  Created by Nilson Junior on 15/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftDate
import Device

private let miniCardReuseIdentifier = "MiniCardFavoriteCell"
private let miniCardHeaderReuseIdentifier = "MiniCardFavoriteHeaderCell"
private let miniCardFooterReuseIdentifier = "MiniCardFavoriteFooterCell"

private let nibForHeader = "MiniCardFavoriteHeaderView"
private let nibForFooter = "MiniCardFavoriteFooterView"

class FavoritesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private var dataSource: [MiniLooksFavorite] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        let nibHeader = UINib(nibName: nibForHeader, bundle: nil)
        self.collectionView!.register(nibHeader, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: miniCardHeaderReuseIdentifier)

        let nibFooter = UINib(nibName: nibForFooter, bundle: nil)
        self.collectionView!.register(nibFooter, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: miniCardFooterReuseIdentifier)


        collectionView?.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        if let layout = collectionView?.collectionViewLayout as? MiniCardsLayout {
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

    func fakeData() {
        CardService.cs.get(miniCards: { (cards: [MiniLooksFavorite], error: NSError?) in
            self.dataSource = cards
            self.collectionView?.reloadData()
        })
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dataSource.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataSource[section].looks.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: miniCardReuseIdentifier, for: indexPath) as! MiniCardFavoriteCell

        let mini: MiniLooksFavorite? = dataSource[indexPath.section]

        if let miniLook = mini {

            let looks: [MiniLookFavorite]? = miniLook.looks

            if looks?.isEmpty == false {

                let look: MiniLookFavorite = looks![indexPath.row]

                cell.lookImage.af_setImage(withURL: look.lookUrl)

                cell.profileImage.af_setImage(withURL: look.profileUrl)

                cell.profileNameLabel.text = look.profileName

                cell.likesLabel.text = "\(look.likes)"

                cell.hashtagLabel.text = look.hashtag
            }
        }

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if(kind == UICollectionElementKindSectionHeader) {

            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: miniCardHeaderReuseIdentifier, for: indexPath) as! MiniCardFavoriteHeaderView

            let date: DateInRegion? = dataSource[indexPath.section].date

            if let date = date {

                header.dateLabel.text = "\(date.day)"

                header.dayLabel.text = date.weekdayName.cut(at: 2)
            }

            return header
        } else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: miniCardFooterReuseIdentifier, for: indexPath) as! MiniCardFavoriteFooterView
        }
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
        let top: CGFloat = 5.0
        let left: CGFloat = 5.0
        let bottom: CGFloat = 5.0
        let right: CGFloat = 5.0
        
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
}
