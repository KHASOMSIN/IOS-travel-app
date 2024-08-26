//
//  CategoryCollectionViewCell.swift
//  Tavel
//
//  Created by user245540 on 8/4/24.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backroundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        applyShadow(shadowColor: .black)
        imageView.layer.cornerRadius = 5
    }
}
