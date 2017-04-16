//
//  FavoritesCollectionViewController.swift
//  fashionfrau
//
//  Created by Nilson Junior on 15/04/2017.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit
import AlamofireImage
import SwiftDate

private let miniCardReuseIdentifier = "MiniCardCell"
private let miniCardHeaderReuseIdentifier = "MiniCardHeaderCell"

class FavoritesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private var dataSource: [MiniLooksCard] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //        self.collectionView!.register(MiniCardViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
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
        CardService.cs.get(xhr: { (cards: [MiniLooksCard], error: NSError?) in
            self.dataSource = cards
            self.collectionView?.reloadData()
        })
    }
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */

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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: miniCardReuseIdentifier, for: indexPath) as! MiniCardViewCell

        let mini: MiniLooksCard? = dataSource[indexPath.section]

        if let miniLook = mini {

            let looks: [MiniLookCard]? = miniLook.looks

            if looks?.isEmpty == false {

                let look: MiniLookCard = looks![indexPath.row]

                    cell.imageView.af_setImage(withURL: look.lookUrl)
            }
        }
        // Configure the cell

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: miniCardHeaderReuseIdentifier, for: indexPath) as! MiniCardHeaderView

        let date: DateInRegion? = dataSource[indexPath.section].date

        if let date = date {

            header.dateLabel.text = "\(date.day)"

            header.dayLabel.text = date.weekdayName.cut(at: 2)
        }

        return header
    }

    // MARK: UICollectionViewDelegate

    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */

    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */

    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }

     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }

     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {

     }
     */

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
//    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 170, height: 300)
//    }

}
