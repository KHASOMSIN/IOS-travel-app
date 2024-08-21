//
//  TextFieldWithPadding.swift
//  Tavel
//
//  Created by user245540 on 7/23/24.
//

import UIKit

class TextFieldWithPadding: UITextField {

        var textPadding = UIEdgeInsets(
            top: 10,
            left: 20,
            bottom: 10,
            right: 20
        )

        var borderColor: UIColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0) {
            didSet {
                self.layer.borderColor = borderColor.cgColor
            }
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }

        private func setup() {
            // Set default border color
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = 1.0 // You can adjust the border width as needed
            self.layer.cornerRadius = 5.0 // Optional: Adjust corner radius for rounded corners
        }
    
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

        override func textRect(forBounds bounds: CGRect) -> CGRect {
            let rect = super.textRect(forBounds: bounds)
            return rect.inset(by: textPadding)
        }

        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            let rect = super.editingRect(forBounds: bounds)
            return rect.inset(by: textPadding)
    }

}
