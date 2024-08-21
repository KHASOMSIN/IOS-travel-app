//
//  UITextField Extension.swift
//  Tavel
//
//  Created by user245540 on 7/14/24.
//

import UIKit

// Extension UITextField password show and hide passwords:
extension UITextField {
    fileprivate func setPasswordToggleImage(_ button: UIButton) {
        let imageName = isSecureTextEntry ? "Hide" : "Show"
        if let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate) {
            button.setImage(resizeImage(image: image, targetSize: CGSize(width: 20, height: 20)), for: .normal)
        }
    }

    func enablePasswordToggle() {
        let button = UIButton(type: .custom)
        setPasswordToggleImage(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        self.rightView = button
        self.rightViewMode = .always
    }
    @IBAction func togglePasswordView(_ sender: Any) {
        self.isSecureTextEntry.toggle()
        if let button = sender as? UIButton {
            setPasswordToggleImage(button)
        }
    }
    fileprivate func resizeImage(image: UIImage?, targetSize: CGSize) -> UIImage? {
        guard let image = image else { return nil }
        let size = image.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        var newSize: CGSize

        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        let rect = CGRect(origin: .zero, size: newSize)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

