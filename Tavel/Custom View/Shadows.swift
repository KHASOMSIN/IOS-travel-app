//
//  shadows of collectionView Cell.swift
//  Tavel
//
//  Created by user245540 on 7/29/24.
//

import UIKit

extension UICollectionViewCell {
    func applyShadow(cornerRadius: CGFloat = 10, shadowColor: UIColor = .black, shadowOffset: CGSize = CGSize(width: 0, height: 2), shadowRadius: CGFloat = 4, shadowOpacity: Float = 0.3) {
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true

        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }
}

// apply for UIVIew

extension UIView {
    func addShadow(color: UIColor = .black, opacity: Float = 0.5, offset: CGSize = .zero, radius: CGFloat = 5.0, shadowPath: UIBezierPath? = nil) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        
        if let shadowPath = shadowPath {
            self.layer.shadowPath = shadowPath.cgPath
        } else {
            self.layer.shadowPath = nil
        }
    }
}
