import UIKit
import SnapKit
class TripCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    let Viewbackground = UIView()
    
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
        contentView.addSubview(Viewbackground)
        Viewbackground.addSubview(imageView)
    }
    
    private func setConstraints() {
        Viewbackground.snp.makeConstraints { make in
            make.edges.equalTo(contentView).offset(0)
        }
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(Viewbackground).offset(0)
        }
    }
    
    func configure(with model: TripModel) {
        imageView.image = UIImage(named: model.imageName!)
    }
}
