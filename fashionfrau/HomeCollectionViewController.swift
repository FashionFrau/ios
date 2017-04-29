//
//  HomeCollectionViewController.swift
//  fashionfrau
//
//  Created by Nilson Junior on 23.04.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import Device
import Flurry_iOS_SDK
import UIEmptyState

private let miniCardHomeHeaderReuseIdentifier = "MiniCardHomeHeaderCell"
private let miniCardHomeReuseIdentifier = "MiniCardHomeCell"

class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIEmptyStateDataSource, UIEmptyStateDelegate {

    private let nibForHomeHeader = "MiniCardHomeHeaderView"
    
    private let homeCollectionViewControllerDomainError = "home-collection-view-controller"

    private var dataSource: [MiniLookHome] = []

    private var user: User?

    private let emptyAttributes = [ NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Courgette-Regular", size: 15) ??  UIFont.systemFont(ofSize: 15)]

    var emptyStateViewAdjustsToFitBars: Bool =  true

    var emptyStateTitle: NSAttributedString { get { return NSAttributedString(string: "Pull to refresh", attributes: emptyAttributes) } }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        let nibHeader = UINib(nibName: nibForHomeHeader, bundle: nil)
        self.collectionView!.register(nibHeader, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: miniCardHomeHeaderReuseIdentifier)

        self.emptyStateDataSource = self
        self.emptyStateDelegate = self

        fakeUser()

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
        CardService.cs.get(likedCards: { (cards: [MiniLookHome], error: Error?) in
            if error == nil {
                self.dataSource = cards
                self.collectionView?.reloadData()
                self.reloadEmptyState(forCollectionView: self.collectionView!)
            } else {
                Flurry.logError("\(self.homeCollectionViewControllerDomainError).fakeData", message: error?.localizedDescription, error: error)
            }
        })
    }

    func fakeUser() {
        UserService.us.get(userId: "1") { (user:User?, error: Error?) in
            if error == nil, let user = user {
                self.user = user
                self.navigationItem.title = user.profileName
                self.collectionView?.reloadData()
            } else {
                Flurry.logError("\(self.homeCollectionViewControllerDomainError).fakeUser", message: error?.localizedDescription, error: error)
            }
        }
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

        if let user = self.user {
            cell.model = user
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
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
