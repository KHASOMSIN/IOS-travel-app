import UIKit
import SnapKit

class FirstCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let saveButton = UIButton(type: .system)

    var bookmarkButtonAction: (() -> Void)?

    private let circularBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
        saveButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(circularBackgroundView)
        circularBackgroundView.addSubview(saveButton)
        imageView.addSubview(titleLabel)
        imageView.addSubview(descriptionLabel)

        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true

        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white

        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 2

        if let image = UIImage(named: "saved1")?.withRenderingMode(.alwaysTemplate) {
            saveButton.setImage(image, for: .normal)
            saveButton.tintColor = .red
            saveButton.backgroundColor = .clear
            print("Image loaded and tint color set")
        } else {
            print("Failed to load image")
        }

    }

    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(-10)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.leading).offset(10)
            make.trailing.equalTo(imageView.snp.trailing).offset(-10)
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-8)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom).offset(-10)
            make.leading.equalTo(imageView.snp.leading).offset(10)
            make.trailing.equalTo(imageView.snp.trailing).offset(-10)
        }

        circularBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
            make.width.height.equalTo(48)
        }

        saveButton.snp.makeConstraints { make in
            make.center.equalTo(circularBackgroundView.snp.center)
            make.width.height.equalTo(24)
        }
    }

    func configure(with trip: PopularPlace) {
        titleLabel.text = trip.title
        descriptionLabel.text = trip.description

        // Set the image to display if available
        if let imageName = trip.imageName {
            imageView.image = UIImage(named: imageName)
        }

        // Check the bookmark status and update the button image
        let isBookmarked = BookmarkManager.shared.isBookmarked(id: trip.id)
        let imageName = isBookmarked ? "Heart_selected" : "saved1"
        let image = UIImage(named: imageName)?.resize(to: CGSize(width: 24.0, height: 24.0))
        saveButton.setImage(image, for: .normal)
        saveButton.tintColor = .red
    }

    @objc private func bookmarkButtonTapped() {
        bookmarkButtonAction?()
    }
}
