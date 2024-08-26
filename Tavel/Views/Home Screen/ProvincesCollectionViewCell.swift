import UIKit
import SnapKit
import Kingfisher
import Localize_Swift

class ProvincesCollectionViewCell: UICollectionViewCell {
//    var provinceId: Int?
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    let background: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(1) // Adjusted to make it visible
        return view
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0 // Allows multiple lines
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.addSubview(background)
        background.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(60) // Set a height constraint, adjust as needed
        }
        
        background.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview() // Center title label in the background view
            make.leading.trailing.equalToSuperview().inset(10) // Add padding
        }
        
        applyShadow()
    }
    
    func configure(with province: ProvincesModel) {
//        provinceId = province.provinceId
        titleLabel.text = province.provinceName.localized()
        if let url = URL(string: province.provinceImage) {
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
