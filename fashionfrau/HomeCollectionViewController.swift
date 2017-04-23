//
//  HomeCollectionViewController.swift
//  fashionfrau
//
//  Created by Nilson Junior on 23.04.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit

private let homeHeaderReuseIdentifier = "HomeHeaderCell"
private let miniCardHomeReuseIdentifier = "MiniCardHomeCell"

class HomeCollectionViewController: UICollectionViewController {

    private var dataSource: [MiniLooksCard] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Priscilla Hohel"

        collectionView!.backgroundColor = .fashionfrau
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fakeData()
    }

    func fakeData() {
        CardService.cs.get(likedCards: { (cards: [MiniLooksCard], error: NSError?) in
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
    

        let mini: MiniLooksCard? = dataSource[indexPath.row]

        if let miniLook = mini {

            let looks: [MiniLookCard]? = miniLook.looks

            if looks?.isEmpty == false {

                let look: MiniLookCard = looks![indexPath.row]

                cell.lookImage.af_setImage(withURL: look.lookUrl)

                cell.profileImage.af_setImage(withURL: look.profileUrl)

                cell.profileNameLabel.text = look.profileName

                cell.likesLabel.text = "\(look.likes)"
                
//                cell.hashtagLabel.text = look.hashtag
            }
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate


}
