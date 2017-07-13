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

    private let cardsViewControllerDomainError = "com.fashionfrau.cards-view-controller.error"

    let gifManager = SwiftyGifManager(memoryLimit:7)

    @IBOutlet weak var kolodaView: KolodaView!

    @IBOutlet weak var loadingView: UIImageView!

    var dataSource = [Look]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let loadingImage = UIImage(gifName: Images.LoadingImages)
        loadingView.setGifImage(loadingImage, manager: gifManager)


        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards

        kolodaView.dataSource = self
        kolodaView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        fakeData()
    }

    fileprivate func fakeData() {

        if !dataSource.isEmpty {
            return
        }

        loadingView.isHidden = false

        CardService.cs.get(cards: { (cards: [Look], error: Error?) in

            self.loadingView.isHidden = true

            self.dataSource = cards

            self.kolodaView.reloadData()

            if let error = error {

                Flurry.logError("\(self.cardsViewControllerDomainError).fake-data", message: error.localizedDescription, error: error)
            }
        })
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let destination = segue.destination as? CardDetailViewController {

            if let selectedLook = sender as? Look {

                destination.lookId = selectedLook.id

                destination.look = selectedLook
            }
        }
    }
}

extension CardsViewController: KolodaViewDelegate {

    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.resetCurrentCardIndex()
        dataSource.removeAll()
        fakeData()
    }

    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        performSegue(withIdentifier: cardDetailSegue, sender: dataSource[index])
    }

    func kolodaSwipeThresholdRatioMargin(_ koloda: KolodaView) -> CGFloat? {
        return CGFloat(0.5)
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

