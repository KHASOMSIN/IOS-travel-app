//
//  CustomLayout.swift
//  Tavel
//
//  Created by user245540 on 7/28/24.
//

import UIKit

class CustomLayout: UICollectionViewFlowLayout {
    var previousOffset: CGFloat = 0.0
    var currentPage = 0
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        let itemCount = collectionView.numberOfItems(inSection: 0)
        
        if previousOffset > collectionView.contentOffset.x && velocity.x < 0.0 {
            // Scrolling left
            currentPage = max(currentPage - 1, 0)
        } else if previousOffset < collectionView.contentOffset.x && velocity.x > 0.0 {
            // Scrolling right
            currentPage = min(currentPage + 1, itemCount - 1)
        }
        
//        let width = collectionView.frame.width
//        let itemWidth = itemSize.width
//        let spacing = minimumLineSpacing
//        let edge = (width - itemWidth) / 2
//
//        print("Current Page: \(currentPage)")
//
//        let offset = (itemWidth + spacing) * CGFloat(currentPage) - edge
        let offset = updateOffSet(collectionView)
        previousOffset = offset
        
        return CGPoint(x: offset, y: proposedContentOffset.y)
        
    }
    
    func updateOffSet(_ collectionView: UICollectionView) -> CGFloat {
        let width = collectionView.frame.width
        let itemWidth = itemSize.width
        let spacing = minimumLineSpacing
        let edge = (width - itemWidth) / 2
        
        let offset = (itemWidth + spacing) * CGFloat(currentPage) - edge
        previousOffset = offset
        
        return offset
    }
}

