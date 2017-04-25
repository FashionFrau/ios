//
//  HomeCollectionViewController.swift
//  fashionfrau
//
//  Created by Nilson Junior on 23.04.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import Device

private let miniCardHomeHeaderReuseIdentifier = "MiniCardHomeHeaderCell"
private let miniCardHomeReuseIdentifier = "MiniCardHomeCell"

private let nibForHomeHeader = "MiniCardHomeHeaderView"

class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private var dataSource: [MiniLookHome] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        let nibHeader = UINib(nibName: nibForHomeHeader, bundle: nil)
        self.collectionView!.register(nibHeader, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: miniCardHomeHeaderReuseIdentifier)


        navigationItem.title = "Priscilla Hohel"

        collectionView!.backgroundColor = .fashionfrau

        if let layout = collectionView?.collectionViewLayout as? MiniCardsHomeLayout {
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
        CardService.cs.get(likedCards: { (cards: [MiniLookHome], error: NSError?) in
            self.dataSource = cards
            self.collectionView?.reloadData()
        })
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataSource.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: miniCardHomeReuseIdentifier, for: indexPath)  as! MiniCardHomeCell


        let mini: MiniLookHome? = dataSource[indexPath.row]

        if let miniLook = mini {
            cell.model = miniLook
        }
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: miniCardHomeHeaderReuseIdentifier, for: indexPath) as! MiniCardHomeHeaderView
        cell.profileImage.af_setImage(withURL: NSURL(string:"https://scontent.cdninstagram.com/t51.2885-19/s150x150/17126950_1711879765768835_8298910554370605056_a.jpg")! as URL)
        return cell
    }
    
    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
}

extension HomeCollectionViewController: MiniCardsHomeLayoutDelegate {

    func collectionViewMiniCardInset() -> UIEdgeInsets {
        return UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    }

    func collectionViewHeaderHeight() -> CGFloat {
        return 250
    }

    func collectionView(collectionView:UICollectionView) -> CGFloat {
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
}
