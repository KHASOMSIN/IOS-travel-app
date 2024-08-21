//
//  UIView+Extensions.swift
//  Tavel
//
//  Created by user245540 on 7/8/24.
//
import UIKit
extension UIView{
    @IBInspectable var cornerRaduis: CGFloat{
        get{
            return self.cornerRaduis
        }
        set{
            self.layer.cornerRadius = newValue
        }
    }
}



