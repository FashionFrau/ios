//
//  LikedLookCollectionViewController.swift
//  fashionfrau
//
//  Created by Nilson Junior on 23.04.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import Device
import Flurry_iOS_SDK
import Alamofire
import ESPullToRefresh

class LikedLookCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let likedLookCollectionViewControllerDomainError = "com.fashionfrau.liked-look-collection-view-controller.error"

    private var dataSource = [LikedLook]()

    private var user: CurrentUser?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        let nibHeader = UINib(nibName: nibForLikedLookHeader, bundle: nil)

        collectionView!.register(nibHeader, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: LikedLookHeaderReuseIdentifier)

        collectionView!.dataSource = self

        collectionView!.backgroundColor = .fashionfrau

        if let layout = collectionView!.collectionViewLayout as? LikedLookLayout {
            layout.delegate = self
        }

        setupESPullToRefresh()
    }

    func loadData() {

        loadUser()

        LookService.ls.get { (cards: [LikedLook], errorResponse: ErrorResponse) in
            self.collectionView!.es_stopPullToRefresh()

            self.dataSource = cards

            self.collectionView!.reloadData()

            if let error = errorResponse.error {

                Flurry.logError("\(self.likedLookCollectionViewControllerDomainError).load-data", message: error.localizedDescription, error: error)
            }

        }
    }

    func loadUser() {

        do {
            self.user = try UserService.us.getCurrentUser()

            self.navigationItem.title = self.user?.username

            self.collectionView!.reloadData()

        } catch let error {

            Flurry.logError("\(self.likedLookCollectionViewControllerDomainError).load-user", message: error.localizedDescription, error: error)

            self.redirectToLogin()

        }
    }

    func setupESPullToRefresh() {

        collectionView!.alwaysBounceVertical = true

        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol

        header = FFRefreshHeaderAnimator.init(frame: CGRect.zero)

        collectionView!.es_addPullToRefresh(animator: header) {
            self.loadData()
        }

        collectionView!.es_startPullToRefresh()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LookDetailViewController {
            if let selectedLook = sender as? LikedLook {
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

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikedLookReuseIdentifier, for: indexPath)  as! LikedLookCell

        let mini: LikedLook? = dataSource[indexPath.row]

        if let miniLook = mini {

            cell.model = miniLook
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LikedLookHeaderReuseIdentifier, for: indexPath) as! LikedLookHeaderView

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
        performSegue(withIdentifier: LookDetailSegue, sender: dataSource[indexPath.row])
    }
}

extension LikedLookCollectionViewController: LikedLookLayoutDelegate {

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
