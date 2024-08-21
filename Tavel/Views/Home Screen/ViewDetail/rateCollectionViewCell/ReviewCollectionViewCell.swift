//
//  ReviewCollectionViewCell.swift
//  Travel
//
//  Created by user245540 on 8/5/24.
//

import UIKit
import SnapKit

class ReviewCollectionViewCell: UICollectionViewCell {
    
    let imageProfile = UIImageView()
    let nameLabel = UILabel()
    let ratingStars = UIStackView()
    let createdDateLabel = UILabel()
    let reviewDetailLabel = UILabel()
    let viewBackground = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setConstraints()
    }
    
    private func setupViews() {
        contentView.addSubview(viewBackground)
        viewBackground.addSubview(imageProfile)
        viewBackground.addSubview(nameLabel)
        viewBackground.addSubview(ratingStars)
        viewBackground.addSubview(createdDateLabel)
        viewBackground.addSubview(reviewDetailLabel)
        viewBackground.backgroundColor = .white
        viewBackground.layer.cornerRadius = 13
        viewBackground.addShadow()
        
        
        imageProfile.contentMode = .scaleAspectFill
        imageProfile.layer.cornerRadius = 25
        imageProfile.clipsToBounds = true
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = .black
        
        ratingStars.axis = .horizontal
        ratingStars.alignment = .center
        ratingStars.distribution = .fillEqually
        ratingStars.spacing = 2
        
        createdDateLabel.font = UIFont.systemFont(ofSize: 12)
        createdDateLabel.textColor = .gray
        
        reviewDetailLabel.font = UIFont.systemFont(ofSize: 14)
        reviewDetailLabel.textColor = .darkGray
        reviewDetailLabel.numberOfLines = 0
    }
    
    private func setConstraints() {
        viewBackground.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(8)
        }
            
        imageProfile.snp.makeConstraints { make in
            make.top.left.equalTo(viewBackground).inset(10)
            make.width.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(viewBackground).inset(15)
            make.left.equalTo(imageProfile.snp.right).offset(10)
            make.right.equalTo(viewBackground).inset(8)
        }
        
        ratingStars.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.left.equalTo(imageProfile.snp.right).offset(10)
        }
        
        createdDateLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingStars.snp.bottom).offset(5)
            make.left.equalTo(imageProfile.snp.right).offset(10)
            make.right.equalTo(viewBackground).inset(10)
        }
        
        reviewDetailLabel.snp.makeConstraints { make in
            make.top.equalTo(createdDateLabel.snp.bottom).offset(5)
            make.left.equalTo(imageProfile.snp.right).offset(10)
            make.right.equalTo(viewBackground).inset(10)
            make.bottom.equalTo(viewBackground).inset(5)
        }
    }
    
    func configure(with model: ReviewModel) {
        if let profileImageName = model.profileImageName, !profileImageName.isEmpty {
            imageProfile.image = UIImage(named: profileImageName)
        } else {
            imageProfile.image = nil // or set a placeholder image
        }
        nameLabel.text = model.name
        setupRatingStars(rating: model.rating)
        createdDateLabel.text = model.createdDate
        reviewDetailLabel.text = model.reviewDetail
    }
    
    private func setupRatingStars(rating: Int) {
        ratingStars.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if #available(iOS 13.0, *) {
            for _ in 0..<rating {
                let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
                starImageView.tintColor = UIColor(hex: "F9E400")
                ratingStars.addArrangedSubview(starImageView)
            }
            
            for _ in rating..<5 {
                let starImageView = UIImageView(image: UIImage(systemName: "star"))
                starImageView.tintColor = UIColor(hex: "F9E400")
                ratingStars.addArrangedSubview(starImageView)
            }
        } else {
            let filledStarImage = UIImage(named: "filled_star") // replace with your filled star image asset
            let emptyStarImage = UIImage(named: "empty_star") // replace with your empty star image asset
            
            for _ in 0..<rating {
                let starImageView = UIImageView(image: filledStarImage)
                starImageView.tintColor = .yellow
                ratingStars.addArrangedSubview(starImageView)
            }
            
            for _ in rating..<5 {
                let starImageView = UIImageView(image: emptyStarImage)
                starImageView.tintColor = .yellow
                ratingStars.addArrangedSubview(starImageView)
            }
        }
    }
}
