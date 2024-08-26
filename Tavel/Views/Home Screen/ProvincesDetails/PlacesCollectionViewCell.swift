import UIKit
import SnapKit

class PlacesCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let backView = UIView()
    private let detailLabel = UILabel()
    private let locationIcon = UIImageView()
    let locationLabel = UILabel()
    private let backgroundViewContainer = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
        applyShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setConstraints()
    }
    
    private func setupViews() {
        contentView.addSubview(backgroundViewContainer)
        backgroundViewContainer.addSubview(imageView)
        
        imageView.addSubview(backView)
        backView.backgroundColor = .white.withAlphaComponent(0.9)
        
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.numberOfLines = 2
        backView.addSubview(titleLabel)
        
        locationIcon.contentMode = .scaleAspectFit
        backView.addSubview(locationIcon)
        locationIcon.image = UIImage(named: "Location")
        
        locationLabel.font = UIFont.systemFont(ofSize: 13)
        backView.addSubview(locationLabel)
        
        detailLabel.font = UIFont.systemFont(ofSize: 12)
        detailLabel.textColor = UIColor.gray
        detailLabel.numberOfLines = 0
        backView.addSubview(detailLabel)
    }
    
    private func setConstraints() {
        backgroundViewContainer.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(backgroundViewContainer)
        }
        
        backView.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom)
            make.left.equalTo(imageView.snp.left)
            make.right.equalTo(imageView.snp.right)
            make.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.top).offset(5)
            make.left.equalTo(backView.snp.left).offset(5)
            make.right.equalTo(backView.snp.right).offset(-5)
        }
        
        locationIcon.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(backView.snp.left).offset(5)
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationIcon.snp.centerY)
            make.left.equalTo(locationIcon.snp.right).offset(5)
            make.right.equalTo(backView.snp.right).offset(-5)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(locationIcon.snp.bottom).offset(5)
            make.left.equalTo(backView.snp.left).offset(5)
            make.right.equalTo(backView.snp.right).offset(-5)
            make.bottom.equalTo(backView.snp.bottom).offset(-5)
        }
    }

    func configure(with place: Pupular) {
        titleLabel.text = place.placeName
        detailLabel.text = place.description
        locationLabel.text = place.provinceName
        if let url = URL(string: place.imageUrl) {
            imageView.kf.setImage(with: url)
        }
    }
}
