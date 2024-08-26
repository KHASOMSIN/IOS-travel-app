import UIKit
import SnapKit
import Kingfisher

class ProvincesGalleryCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
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
        viewBackground.addSubview(imageView)
        
        // Configure the imageView
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        viewBackground.layer.cornerRadius = 10
        viewBackground.clipsToBounds = true
    }
    
    private func setConstraints() {
        viewBackground.snp.makeConstraints { make in
            make.edges.equalTo(contentView).offset(0)
        }
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(viewBackground).offset(0)
        }
    }
    
    func configure(with model: ProvinceImage) {
        if let imageUrlString = model.imageUrl, let imageUrl = URL(string: imageUrlString) {
            imageView.kf.setImage(
                with: imageUrl,
                placeholder: UIImage(named: "placeholder"),
                options: [
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
        } else {
            imageView.image = UIImage(named: "errorImage")
        }
    }
}
