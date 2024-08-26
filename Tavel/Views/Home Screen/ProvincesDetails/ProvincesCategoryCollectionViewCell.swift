import UIKit
import SnapKit

class ProvincesCategoryCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
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
        contentView.backgroundColor = .white
        
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
    }
    
    private func setConstraints() {
        backgroundViewContainer.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalTo(backgroundViewContainer)
            make.height.equalTo(imageView.snp.width) // Maintain aspect ratio
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.bottom.equalTo(backgroundViewContainer.snp.bottom).offset(-8)
            make.left.right.equalTo(backgroundViewContainer)
        }
    }
    
    func configure(with category: Category) {
            titleLabel.text = category.categoryTitle
            if let url = URL(string: category.imageIcon) {
                imageView.kf.setImage(with: url)
        }
    }
}
