//
//  extension function.swift
//  Tavel
//
//  Created by user245540 on 8/7/24.
//
import UIKit
extension ProvinceDetailViewController {
    func customizeButton() {
        // Set the button image
        if let buttonImage = UIImage(named: "share") {
            let resizedImage = ImageResizer.resizeImage(image: buttonImage, targetSize: CGSize(width: 20, height: 20))
            shareBtn.setImage(resizedImage, for: .normal)
        }
        
        shareBtn.setTitle("Share", for: .normal)
        shareBtn.setTitleColor(.black, for: .normal) // Customize title color
        shareBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
        shareBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        shareBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func rightSearchBtnTapped(){
        if isSearching {
                    // Hide searchTextField and change button to search icon
            searchTextField.isHidden = true
                    updateRightButtonIcon(to: "search1")
        } else {
                    // Show searchTextField and change button to cancel icon
            searchTextField.isHidden = false
            updateRightButtonIcon(to: "close")
        }
        isSearching.toggle() // Toggle the state
    }
    
    func setupCustomBackButton() {
        let backButton = UIButton()
        if let image = UIImage(named: "Arrow - Left") {
            let resizedImage = ImageResizer.resizeImage(image: image, targetSize: CGSize(width: 20, height: 20))
            backButton.setImage(resizedImage, for: .normal)
        }
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
        
        updateRightButtonIcon(to: "search1")
    }
    
    func updateRightButtonIcon(to iconName: String) {
            let rightSearchButton = UIButton()
            if let image = UIImage(named: iconName) {
                if iconName == "search1" {
                    let resizedImage = ImageResizer.resizeImage(image: image, targetSize: CGSize(width: 30, height: 30))
                    rightSearchButton.setImage(resizedImage, for: .normal)
                } else {
                    let resizedImage = ImageResizer.resizeImage(image: image, targetSize: CGSize(width: 20, height: 20))
                    rightSearchButton.setImage(resizedImage, for: .normal)
                    
                }
                
            }
            rightSearchButton.addTarget(self, action: #selector(rightSearchBtnTapped), for: .touchUpInside)
            let rightButtonItem = UIBarButtonItem(customView: rightSearchButton)
            navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        
        if contentOffsetY >= 373.5 {
            scrollView.isScrollEnabled = false
        }
        
        if contentOffsetY < 373.5 {
            scrollView.isScrollEnabled = true
        }
    }
}
