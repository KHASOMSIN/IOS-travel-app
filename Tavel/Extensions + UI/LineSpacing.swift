//
//  LineSpacing.swift
//  Tavel
//
//  Created by user245540 on 8/2/24.
//

import UIKit

extension UILabel {
    func setLineSpacing(lineSpacing: CGFloat) {
        guard let text = self.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        
        self.attributedText = attributedString
    }
}

