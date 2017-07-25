//
//  CardsViewController.swift
//  fashionfrau
//
//  Created by Nilson Junior on 10/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import Koloda
import Flurry_iOS_SDK
import SwiftyGif

private let cardDetailSegue = "CardDetailViewController"

class CardsViewController: UIViewController {

    private let kolodaCountOfVisibleCards = 2

    private let kolodaAlphaValueSemiTransparent: CGFloat = 0.0

    fileprivate let cardsViewControllerDomainError = "com.fashionfrau.cards-view-controller.error"

    let gifManager = SwiftyGifManager(memoryLimit:7)

    @IBOutlet weak var kolodaView: KolodaView!

    @IBOutlet weak var loadingView: UIImageView!

    var dataSource = [Look]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let loadingImage = UIImage(gifName: Images.LoadingCards)
        loadingView.setGifImage(loadingImage, manager: gifManager)

        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards

        kolodaView.dataSource = self
        kolodaView.delegate = self
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

        CardService.cs.get { (cards: [Look], errorResponse: ErrorResponse) in

            if let error = errorResponse.error {

                Flurry.logError("\(self.cardsViewControllerDomainError).fake-data", message: error.localizedDescription, error: error)
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

        if let destination = segue.destination as? CardDetailViewController {

            if let selectedLook = sender as? Look {

                destination.lookId = selectedLook.id

                destination.look = selectedLook

                destination.delegate = self
            }
        }
    }

    func swipeToLike(cardId: String) {

        CardService.cs.like(cardId: cardId, success: { (response: HTTPURLResponse?) in

        }, failure: { (errorResponse: ErrorResponse) in

            if let error = errorResponse.error {

                Flurry.logError("\(self.cardsViewControllerDomainError).did-swipe-card-at:like", message: error.localizedDescription, error: error)
            }

            if self.isUnauthorized(response: errorResponse.response) {

                self.redirectToLogin()
            }
        })
    }

    func swipeToUnlike(cardId: String) {

        CardService.cs.unlike(cardId: cardId, success: { (response: HTTPURLResponse?) in

        }, failure: { (errorResponse: ErrorResponse) in

            if let error = errorResponse.error {

                Flurry.logError("\(self.cardsViewControllerDomainError).did-swipe-card-at:unlike", message: error.localizedDescription, error: error)
            }

            if self.isUnauthorized(response: errorResponse.response) {

                self.redirectToLogin()
            }
        })
    }
}

extension CardsViewController: KolodaViewDelegate {

    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {

        kolodaView.resetCurrentCardIndex()

        loadData()
    }

    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        performSegue(withIdentifier: cardDetailSegue, sender: dataSource[index])
    }

    func kolodaSwipeThresholdRatioMargin(_ koloda: KolodaView) -> CGFloat? {
        return CGFloat(0.5)
    }

    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {

        let card = dataSource[index]

        switch direction {

        case .left: self.swipeToUnlike(cardId: card.id)

        case .right: self.swipeToLike(cardId: card.id)

        default:
            return
        }
    }
}

extension CardsViewController: KolodaViewDataSource {

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

extension CardsViewController: CardDetailDelegate {

    func didSwipeCard(cardId: String, in direction: SwipeResultDirection) {

        self.kolodaView.swipe(direction)
    }
}

