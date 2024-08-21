import UIKit
import SnapKit

class PlanCollectionViewCell: UICollectionViewCell {
    // Define UI elements
    let backView = UIView()
    let imageIcon = UIImageView()
    let planNameLabel = UILabel()
    let datelabel = UILabel()
    let peopleLabel = UILabel()
    let placeNameLabel = UILabel()
    let moreButton = UIButton()
    
    // Closure properties for edit and delete actions
    var editAction: (() -> Void)?
    var deleteAction: (() -> Void)?
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    // Method to setup views
    private func setupViews() {
        // Configure backView
        contentView.addSubview(backView)
        backView.backgroundColor = .white
        backView.layer.cornerRadius = 8
        backView.addShadow(color: .black, opacity: 0.2)
        
        // Configure moreButton
        if let imageMore = UIImage(named: "more")?.resize(to: CGSize(width: 24, height: 24)) {
            moreButton.setImage(imageMore, for: .normal)
        }
        backView.addSubview(moreButton)
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        
        // Configure imageIcon
        imageIcon.image = UIImage(named: "sheet")
        backView.addSubview(imageIcon)
        planNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        backView.addSubview(planNameLabel)
        
        // Configure labels
        [datelabel, peopleLabel, placeNameLabel].forEach {
            $0.font = UIFont.systemFont(ofSize: 14)
            backView.addSubview($0)
        }
    }
    
    // Method to setup constraints
    private func setupConstraints() {
        // Constraints for backView
        backView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(20)
            make.right.equalTo(contentView.snp.right).offset(-20)
            make.top.equalTo(contentView.snp.top).offset(5)
            make.bottom.equalTo(contentView.snp.bottom).offset(-5)
        }
        
        // Constraints for moreButton
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.top).offset(5)
            make.right.equalTo(backView.snp.right).offset(-10)
            make.width.height.equalTo(24) // Set size to match image
        }
        
        // Constraints for imageIcon
        imageIcon.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.top).offset(10)
            make.left.equalTo(backView.snp.left).offset(5)
            make.bottom.equalTo(backView.snp.bottom).offset(-5)
            make.width.equalTo(100)
        }
        
        // Constraints for planNameLabel
        planNameLabel.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.top).offset(15)
            make.left.equalTo(imageIcon.snp.right).offset(5)
            make.right.equalTo(moreButton.snp.left).offset(-5)
        }
        
        // Constraints for placeNameLabel
        placeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(planNameLabel.snp.bottom).offset(10)
            make.left.equalTo(imageIcon.snp.right).offset(5)
            make.right.equalTo(backView.snp.right).offset(-5)
        }
        
        // Constraints for datelabel
        datelabel.snp.makeConstraints { make in
            make.top.equalTo(placeNameLabel.snp.bottom).offset(10)
            make.left.equalTo(imageIcon.snp.right).offset(5)
            make.right.equalTo(backView.snp.right).offset(-5)
        }
        
        // Constraints for peopleLabel
        peopleLabel.snp.makeConstraints { make in
            make.top.equalTo(datelabel.snp.bottom).offset(10)
            make.left.equalTo(imageIcon.snp.right).offset(5)
            make.right.equalTo(backView.snp.right).offset(-5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Method to configure the cell with data
    func configure(with travelPlan: TravelPlan) {
        planNameLabel.text = travelPlan.planName
        placeNameLabel.text = travelPlan.placeName
        datelabel.text = travelPlan.date
        peopleLabel.text = travelPlan.tripMember
    }
    
    // Handle more button tap
    @objc private func moreButtonTapped() {
        guard let parentViewController = self.parentViewController else { return }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { [weak self] _ in
            self?.editAction?()
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteAction?()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(editAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        parentViewController.present(alertController, animated: true, completion: nil)
    }
}

// Extension to find the parent view controller
extension UIView {
    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder?.next
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
