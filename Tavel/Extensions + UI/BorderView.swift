//
//  BorderView.swift
//  Tavel
//
//  Created by user245540 on 8/10/24.
//

import UIKit


class BorderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBorder()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBorder()
    }
    
    private func setupBorder() {
        // Set the border color
        self.layer.borderColor = UIColor.gray.cgColor
        
        // Set the border width
        self.layer.borderWidth = 1.0
        
        // Optional: Set the corner radius for rounded corners
        self.layer.cornerRadius = 8.0
        
        // Optional: Enable masksToBounds to apply corner radius
        self.layer.masksToBounds = true
    }
}

