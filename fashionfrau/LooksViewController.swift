//
//  LooksViewController.swift
//  fashionfrau
//
//  Created by Nilson Junior on 10/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import Koloda
import Flurry_iOS_SDK
import SwiftyGif

class LooksViewController: UIViewController {

    fileprivate let categories = ["All", "Bikini", "Vestido", "Saia", "Top", "Body"]

    private let kolodaCountOfVisibleCards = 2

    private let kolodaAlphaValueSemiTransparent: CGFloat = 0.0

    fileprivate let looksViewControllerDomainError = "com.fashionfrau.looks-view-controller.error"

    let gifManager = SwiftyGifManager(memoryLimit:7)

    @IBOutlet weak var topMenuCollectionView: TopMenuCollectionView!

    @IBOutlet weak var kolodaView: KolodaView!

    @IBOutlet weak var loadingView: UIImageView!

    var dataSource = [Look]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let loadingImage = UIImage(gifName: Images.LoadingLooks)
        loadingView.setGifImage(loadingImage, manager: gifManager)

        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards

        kolodaView.dataSource = self
        kolodaView.delegate = self

        topMenuCollectionView.delegate = self
        topMenuCollectionView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loadData()
    }

    fileprivate func loadData() {

        if !dataSource.isEmpty {
            return
        }

        loadingView.isHidden = false

        LookService.ls.get { (cards: [Look], errorResponse: ErrorResponse) in

            if let error = errorResponse.error {

                Flurry.logError("\(self.looksViewControllerDomainError).load-data", message: error.localizedDescription, error: error)
            }

            if self.isUnauthorized(response: errorResponse.response) {

                self.redirectToLogin()
            }

            self.loadingView.isHidden = true

            self.dataSource = cards

            self.kolodaView.reloadData()
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let destination = segue.destination as? LookDetailViewController {

            if let selectedLook = sender as? Look {

                destination.lookId = selectedLook.id

                destination.look = selectedLook

                destination.delegate = self
            }
        }
    }

    func swipeToLike(cardId: String) {

        LookService.ls.like(lookId: cardId, success: { (response: HTTPURLResponse?) in

        }, failure: { (errorResponse: ErrorResponse) in

            if let error = errorResponse.error {

                Flurry.logError("\(self.looksViewControllerDomainError).did-swipe-look-at:like", message: error.localizedDescription, error: error)
            }

            if self.isUnauthorized(response: errorResponse.response) {

                self.redirectToLogin()
            }
        })
    }

    func swipeToUnlike(lookId: String) {

        LookService.ls.unlike(lookId: lookId, success: { (response: HTTPURLResponse?) in

        }, failure: { (errorResponse: ErrorResponse) in

            if let error = errorResponse.error {

                Flurry.logError("\(self.looksViewControllerDomainError).did-swipe-look-at:unlike", message: error.localizedDescription, error: error)
            }

            if self.isUnauthorized(response: errorResponse.response) {

                self.redirectToLogin()
            }
        })
    }
}

extension LooksViewController: KolodaViewDelegate {

    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {

        kolodaView.resetCurrentCardIndex()

        loadData()
    }

    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        performSegue(withIdentifier: LookDetailSegue, sender: dataSource[index])
    }

    func kolodaSwipeThresholdRatioMargin(_ koloda: KolodaView) -> CGFloat? {
        return CGFloat(0.5)
    }

    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {

        let card = dataSource[index]

        switch direction {

        case .left: self.swipeToUnlike(lookId: card.id)

        case .right: self.swipeToLike(cardId: card.id)

        default:
            return
        }
    }
}

extension LooksViewController: KolodaViewDataSource {

    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .`default`
    }

    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return dataSource.count
    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view = Bundle.main.loadNibNamed("CardView", owner: self, options: nil)?.first as! CardView
        
        let look = dataSource[index]
        
        view.update(look: look)
        
        return view
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("CustomOverlayView",
                                        owner: self, options: nil)?.first as? OverlayView
    }
}

extension LooksViewController: LookDetailDelegate {

    func didSwipeCard(cardId: String, in direction: SwipeResultDirection) {

        self.kolodaView.swipe(direction)
    }
}

extension LooksViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TopMenuCollectionViewCell

        cell.didTouchIn()
    }
}

extension LooksViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopMenuCellReuseIdentifier, for: indexPath) as! TopMenuCollectionViewCell

        cell.category = categories[indexPath.row]

        return cell
    }
}

