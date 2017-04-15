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

    var dataSource:[Look] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fakeData()

        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards

        kolodaView.dataSource = self
        kolodaView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fakeData()     {

        let look1 = LookBuilder {

            $0.profileName = "Ana Silva"

            $0.profileUrl = "https://scontent-frt3-1.cdninstagram.com/t51.2885-19/s150x150/17127296_1262614840440933_6836877955663134720_a.jpg"

            $0.lookUrl = "https://scontent-frt3-1.cdninstagram.com/t51.2885-15/e35/17494160_1142083022564258_3905633462714892288_n.jpg"

            $0.gallery = [
                "https://scontent-fra3-1.cdninstagram.com/t51.2885-15/e35/17883078_289685971454205_4727388700760080384_n.jpg",
                "https://scontent-fra3-1.cdninstagram.com/t51.2885-15/e35/17932436_713174052219286_4672224724925808640_n.jpg",
                "https://scontent-fra3-1.cdninstagram.com/t51.2885-15/e35/17881451_1896584557254568_3574482997337915392_n.jpg"]
        }

        let look2 = LookBuilder { builder in

            builder.profileName = "Renata B"

            builder.profileUrl = "https://scontent-frt3-1.cdninstagram.com/t51.2885-19/s150x150/17265901_1846484565594039_8534257844315226112_a.jpg"

            builder.lookUrl = "https://scontent-frt3-1.cdninstagram.com/t51.2885-15/e35/17818088_1703057943325391_4281203192831672320_n.jpg"

            builder.gallery = [ "https://scontent-fra3-1.cdninstagram.com/t51.2885-15/e35/17932436_713174052219286_4672224724925808640_n.jpg",
                                "https://scontent-fra3-1.cdninstagram.com/t51.2885-15/e35/17881451_1896584557254568_3574482997337915392_n.jpg"]
        }

        let look3 = LookBuilder { builder in

            builder.profileName = "Nadine Uoad"

            builder.profileUrl = "https://scontent-frt3-1.cdninstagram.com/t51.2885-19/s150x150/16464809_660265574175739_5372737941057568768_a.jpg"

            builder.lookUrl = "https://scontent-frt3-1.cdninstagram.com/t51.2885-15/e35/17495355_1453839204662143_6199975764985643008_n.jpg"
            builder.gallery = ["https://scontent-fra3-1.cdninstagram.com/t51.2885-15/e35/17881451_1896584557254568_3574482997337915392_n.jpg"]
        }

        let ll1 = try! Look(builder: look1)
        let ll2 = try! Look(builder: look2)
        let ll3 = try! Look(builder: look3)
        dataSource = [ll1!, ll2!, ll3!]
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CardDetailViewController {
            if let selectedLook = sender as? Look {
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

