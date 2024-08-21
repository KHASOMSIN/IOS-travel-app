//
//  OnboardingCollectionViewCell.swift
//  Tavel
//
//  Created by user245540 on 7/10/24.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var slideTitleLabel: UILabel!
    @IBOutlet weak var slideDescriptionsLabel: UILabel!
    
    func setup(_ slide: OnboardingSlides){
        slideImageView.image = slide.images
        slideTitleLabel.text = slide.title
        slideDescriptionsLabel.text = slide.decsr
    }
}
