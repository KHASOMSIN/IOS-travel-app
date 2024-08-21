//
//  CreatePlanExtension.swift
//  Tavel
//
//  Created by user245540 on 8/10/24.
//

import UIKit

extension CreatePlanViewController {
    func setupCustomBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "custom_back_icon"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//         Set navigation bar to have a white background
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
//        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .white  // Set the background color to white
        self.navigationController?.navigationBar.tintColor = .blue // Tint color for bar button items
        
        // Set title text color
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        // Remove 'Back' text and Title from Navigation Bar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = "Plan a new trip"
    }
}

