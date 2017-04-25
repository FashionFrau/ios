//
//  MiniCardsFavoriteLayout.swift
//  fashionfrau
//
//  Created by Nilson Junior on 21.04.17.
//  Copyright © 2017 Fashion Frau. All rights reserved.
//

import UIKit

protocol MiniCardsLayoutDelegate {

    func collectionViewMiniCardInset() -> UIEdgeInsets
    func collectionViewHeaderWidthPercentage() -> CGFloat
    func collectionViewFooterHeight() -> CGFloat
    func collectionView(collectionView:UICollectionView, heightForMiniCardWithWidth:CGFloat) -> CGFloat
}

class MiniCardsFavoriteLayout: UICollectionViewLayout {

    var delegate: MiniCardsLayoutDelegate!

    let numberOfColumns = 2

    var headerMiniCardHeight: CGFloat = 0.0

    var footerHeight: CGFloat {
        return delegate.collectionViewFooterHeight()
    }

    var footerWidth:CGFloat {
        return collectionView!.bounds.width
    }

    var headerContentWidth: CGFloat {
        let percentageWidth: CGFloat = delegate.collectionViewHeaderWidthPercentage()
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width * percentageWidth - (insets.left + insets.right)
    }

    var rowHeight: CGFloat = 0.0

    let spaceBetweenRows: CGFloat = 10.0

    //    Attributes
    fileprivate var headerAttributes = [UICollectionViewLayoutAttributes]()
    fileprivate var miniCardsAttributes = [UICollectionViewLayoutAttributes]()
    fileprivate var footerAttributes = [UICollectionViewLayoutAttributes]()

    //  ViewContentSize
    fileprivate var contentHeight: CGFloat = 0.0
    fileprivate var contentWidth: CGFloat {
        return collectionView!.bounds.width
    }

    fileprivate var miniCardContentWidth: CGFloat {
        return collectionView!.bounds.width - headerContentWidth
    }

    var headerXOffset: CGFloat = 0.0
    var headerYOffset: CGFloat = 0.0
    var footerXOffset: CGFloat = 0.0

    var miniCardCellColumn:Int = 0

    var miniCardCellXOffset = [CGFloat]()
    var miniCardCellYOffset: [CGFloat] = []

    override func prepare() {

        if (collectionView == nil) {
            return
        }

        headerAttributes.removeAll()
        miniCardsAttributes.removeAll()
        footerAttributes.removeAll()

        let miniCardInset = delegate.collectionViewMiniCardInset()
        let miniCardCellColumnWidth = miniCardContentWidth / CGFloat(numberOfColumns)

        for column in 0 ..< numberOfColumns {
            miniCardCellXOffset.append(headerContentWidth + CGFloat(column) * miniCardCellColumnWidth)
        }
        miniCardCellColumn = 0
        miniCardCellYOffset = [CGFloat](repeating: 0, count: numberOfColumns)


        headerMiniCardHeight = delegate.collectionView(collectionView: collectionView!, heightForMiniCardWithWidth: headerContentWidth)
        rowHeight = headerMiniCardHeight + footerHeight + spaceBetweenRows

        for section in 0 ..< collectionView!.numberOfSections {

            // HEADER FRAME =====================================================================================
            let headerIndexPath = IndexPath(item: 0, section: section)
            let headerCellAttributes =
                UICollectionViewLayoutAttributes(
                    forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                    with: headerIndexPath)


            headerYOffset = CGFloat(section) * rowHeight
            let headerWidthOffset = headerContentWidth

            headerCellAttributes.frame = CGRect(x: headerXOffset, y: headerYOffset, width: headerWidthOffset, height: headerMiniCardHeight)
            headerAttributes.append(headerCellAttributes)

            // MINICARD FRAME =====================================================================================
            for miniCard in 0 ..< collectionView!.numberOfItems(inSection: section) {

                let miniCardIndexPath = IndexPath(item: miniCard, section: section)

                let miniCardAttributes = UICollectionViewLayoutAttributes(forCellWith: miniCardIndexPath)


                let miniCardXOffeset = miniCardCellXOffset[miniCardCellColumn] + miniCardInset.left
                let miniCardYOffeset = miniCardCellYOffset[miniCardCellColumn]

                miniCardAttributes.frame = CGRect(x: miniCardXOffeset, y: miniCardYOffeset, width: miniCardCellColumnWidth - (miniCardInset.left + miniCardInset.right), height: headerMiniCardHeight)
                miniCardsAttributes.append(miniCardAttributes)

                miniCardCellYOffset[miniCardCellColumn] = miniCardCellYOffset[miniCardCellColumn] + rowHeight

                miniCardCellColumn = miniCardCellColumn >= (numberOfColumns - 1) ? 0 : miniCardCellColumn + 1

            }

            // FOOTER FRAME =====================================================================================
            let footerIndexPath = IndexPath(item: 0, section: section)
            let footerCellAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: footerIndexPath)

            footerXOffset = headerXOffset
            let footerYOffset = headerCellAttributes.frame.maxY
            footerCellAttributes.frame = CGRect(x: footerXOffset, y: footerYOffset, width: footerWidth, height: footerHeight)
            footerAttributes.append(footerCellAttributes)

            // REAJUST CONTENT SIZE =====================================================================================
            contentHeight = max(contentHeight, footerCellAttributes.frame.maxY)
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

        for attributes in footerAttributes {
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
