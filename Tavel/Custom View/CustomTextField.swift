import UIKit

class CustomTextField: UITextField {

    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        textAlignment = .left
        let placeholderText = placeholder ?? ""
        attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                .foregroundColor: UIColor.lightGray,
                .paragraphStyle: NSMutableParagraphStyle().apply(configure: {
                    $0.alignment = .left
                })
            ]
        )
    }
    
    // Function to setup left icon
    func setupLeftIcon(_ leftIcon: UIImage?) {
        if let leftIcon = leftIcon {
            let leftIconView = UIImageView(frame: CGRect(x: 6, y: 0, width: 24, height: 24))
            leftIconView.image = leftIcon
            leftIconView.contentMode = .scaleAspectFit
            
            let leftIconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
            leftIconContainerView.addSubview(leftIconView)
            
            leftView = leftIconContainerView
            leftViewMode = .always
        }
    }
}

extension NSMutableParagraphStyle {
    func apply(configure: (NSMutableParagraphStyle) -> Void) -> NSMutableParagraphStyle {
        configure(self)
        return self
    }
}
