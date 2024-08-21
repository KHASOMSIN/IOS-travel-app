import UIKit
import SnapKit

class ProvincesCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
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
    
    let titleLabel: UILabel = {
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
    
    func configure(with trip: ProvincesModel) {
        titleLabel.text = trip.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
