//
//  LikedLookLayout.swift
//  fashionfrau
//
//  Created by Nilson Junior on 25.04.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit

protocol LikedLookLayoutDelegate {

    func collectionViewMiniCardInset() -> UIEdgeInsets
    func collectionViewHeaderHeight() -> CGFloat
    func collectionView(collectionView:UICollectionView) -> CGFloat
}


class LikedLookLayout: UICollectionViewLayout {

    var delegate: LikedLookLayoutDelegate!

    let numberOfColumns = 2

    var miniCardHeight: CGFloat = 0.0

    var rowHeight: CGFloat = 0.0

    let spaceBetweenRows: CGFloat = 10.0

    var headerHeight: CGFloat {
        return delegate.collectionViewHeaderHeight()
    }

    var headerWidth:CGFloat {
        return collectionView!.bounds.width
    }

    fileprivate var headerAttributes = [UICollectionViewLayoutAttributes]()
    fileprivate var miniCardsAttributes = [UICollectionViewLayoutAttributes]()

    fileprivate var contentHeight: CGFloat = 0.0
    fileprivate var contentWidth: CGFloat {
        return collectionView!.bounds.width
    }

    fileprivate var miniCardContentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }


    var headerXOffset: CGFloat = 0.0
    var headerYOffset: CGFloat = 0.0

    var miniCardCellColumn:Int = 0

    var miniCardCellXOffset = [CGFloat]()
    var miniCardCellYOffset: [CGFloat] = []


    override func prepare() {

        if (collectionView == nil) {
            return
        }

        headerAttributes.removeAll()
        miniCardsAttributes.removeAll()


        let miniCardInset = delegate.collectionViewMiniCardInset()
        let miniCardCellColumnWidth = miniCardContentWidth / CGFloat(numberOfColumns)

        for column in 0 ..< numberOfColumns {
            miniCardCellXOffset.append(CGFloat(column) * miniCardCellColumnWidth)
        }
        miniCardCellColumn = 0
        miniCardCellYOffset = [CGFloat](repeating: headerHeight, count: numberOfColumns)

        miniCardHeight = delegate.collectionView(collectionView: collectionView!)
        rowHeight = miniCardHeight + spaceBetweenRows

        for section in 0 ..< collectionView!.numberOfSections {

            // HEADER FRAME =====================================================================================
            let headerIndexPath = IndexPath(item: 0, section: section)
            let headerCellAttributes =
                UICollectionViewLayoutAttributes(
                    forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                    with: headerIndexPath)

            headerCellAttributes.frame = CGRect(x: 0, y: 0, width: headerWidth, height: headerHeight)
            headerAttributes.append(headerCellAttributes)


            // MINICARD FRAME =====================================================================================
            for miniCard in 0 ..< collectionView!.numberOfItems(inSection: section) {

                let miniCardIndexPath = IndexPath(item: miniCard, section: section)

                let miniCardAttributes = UICollectionViewLayoutAttributes(forCellWith: miniCardIndexPath)


                let miniCardXOffeset = miniCardCellXOffset[miniCardCellColumn] + miniCardInset.left
                let miniCardYOffeset = miniCardCellYOffset[miniCardCellColumn]

                miniCardAttributes.frame = CGRect(x: miniCardXOffeset, y: miniCardYOffeset, width: miniCardCellColumnWidth - (miniCardInset.left + miniCardInset.right), height: miniCardHeight)
                miniCardsAttributes.append(miniCardAttributes)

                miniCardCellYOffset[miniCardCellColumn] = miniCardCellYOffset[miniCardCellColumn] + rowHeight

                miniCardCellColumn = miniCardCellColumn >= (numberOfColumns - 1) ? 0 : miniCardCellColumn + 1

                contentHeight = max(contentHeight, miniCardAttributes.frame.maxY)
            }
        }
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()

        for attributes in headerAttributes {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }

        for attributes in miniCardsAttributes {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }

        return layoutAttributes

    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return miniCardsAttributes[indexPath.row]
    }

}
