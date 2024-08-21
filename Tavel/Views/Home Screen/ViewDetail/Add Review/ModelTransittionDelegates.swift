//
//  ModelTransittionDelegates.swift
//  Tavel
//
//  Created by user245540 on 8/6/24.
//

import Foundation
import UIKit

class HalfModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
