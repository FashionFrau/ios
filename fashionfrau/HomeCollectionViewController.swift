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
import Alamofire

private let miniCardHomeHeaderReuseIdentifier = "MiniCardHomeHeaderCell"
private let miniCardHomeReuseIdentifier = "MiniCardHomeCell"

private let miniCardDetailSegue =  "CardDetailViewController"

class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let nibForHomeHeader = "MiniCardHomeHeaderView"

    private let homeCollectionViewControllerDomainError = "com.fashionfrau.home-collection-view-controller.error"

    private var dataSource = [MiniLookHome]()

    private var user: User?

    var refresher: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        let nibHeader = UINib(nibName: nibForHomeHeader, bundle: nil)

        collectionView!.register(nibHeader, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: miniCardHomeHeaderReuseIdentifier)

        collectionView!.dataSource = self

        collectionView!.alwaysBounceVertical = true

        setupRefreshControl()

        collectionView!.backgroundColor = .fashionfrau

        if let layout = collectionView!.collectionViewLayout as? MiniCardsHomeLayout {
            layout.delegate = self
        }
    }

    func fakeData() {

        fakeUser()

        CardService.cs.get(likedCards: { (cards: [MiniLookHome], error: Error?) in

            self.refresher.endRefreshing()

            self.dataSource = cards

            self.collectionView!.reloadData()

            if let error = error {

                Flurry.logError("\(self.homeCollectionViewControllerDomainError).fake-data", message: error.localizedDescription, error: error)
            }
        })
    }

    func fakeUser() {
        UserService.us.get(userId: "1", success: { (user: User) in

            self.user = user

            self.navigationItem.title = user.profileName

            self.collectionView!.reloadData()

        }) { (error: Error?) in

            Flurry.logError("\(self.homeCollectionViewControllerDomainError).fake-user", message: error?.localizedDescription, error: error)
        }
    }

    func setupRefreshControl() {
        refresher = UIRefreshControl()

        refresher.tintColor = UIColor.white

        refresher.addTarget(self, action: #selector(fakeData), for: .valueChanged)

        collectionView!.addSubview(refresher)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CardDetailViewController {
            if let selectedLook = sender as? MiniLookHome {
                destination.lookId = selectedLook.id
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
        performSegue(withIdentifier: miniCardDetailSegue, sender: dataSource[indexPath.row])
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
