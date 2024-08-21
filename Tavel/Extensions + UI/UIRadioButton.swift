//
//  RadioButton.swift
//  Tavel
//
//  Created by user245540 on 7/12/24.
//

import Foundation
import UIKit

class RadioButton: UIButton {
    
    // Images for selected and deselected states
    let selectedImage = UIImage(named: "selected_RadioButton")?.withRenderingMode(.alwaysTemplate)
    let deselectedImage = UIImage(named: "deselected_RadioButton")?.withRenderingMode(.alwaysTemplate)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.setImage(deselectedImage, for: .normal)
        self.tintColor = UIColor(hex: "#BFBFBF")  // Set initial tint color for deselected state
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        self.isSelected = !self.isSelected
        updateImage()
    }
    
    private func updateImage() {
        if self.isSelected {
            self.setImage(selectedImage, for: .normal)
            self.tintColor = UIColor(hex: "#34C98E") // Set tint color for selected state
        } else {
            self.setImage(deselectedImage, for: .normal)
            self.tintColor = UIColor(hex: "#BFBFBF") // Set tint color for deselected state
        }
    }
}
