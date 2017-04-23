//
//  CardsViewController.swift
//  fashionfrau
//
//  Created by Nilson Junior on 10/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import Koloda

private let kolodaCountOfVisibleCards = 2

private let kolodaAlphaValueSemiTransparent: CGFloat = 0.0

private let cardDetailSegue = "CardDetailViewController"

class CardsViewController: UIViewController {

    @IBOutlet weak var kolodaView: KolodaView!

    var dataSource: [LookCard] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //        fakeData()

        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards

        kolodaView.delegate = self
        kolodaView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fakeData()
    }

    func fakeData() {
        CardService.cs.get(cards: { (cards: [LookCard], error: NSError?) in
            self.dataSource = cards
            self.kolodaView.reloadData()
        })
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CardDetailViewController {
            if let selectedLook = sender as? LookCard {
                destination.look = selectedLook
            }
        }
    }
}

extension CardsViewController: KolodaViewDelegate {

    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.resetCurrentCardIndex()
    }

    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        performSegue(withIdentifier: cardDetailSegue, sender: dataSource[index])
    }
}

extension CardsViewController: KolodaViewDataSource {

    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return dataSource.count
    }

    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view = Bundle.main.loadNibNamed("CardView", owner: self, options: nil)?.first as! CardView
        view.update(look: dataSource[index])
        return view

    }

    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("CustomOverlayView",
                                        owner: self, options: nil)?.first as? OverlayView
    }
    
}

