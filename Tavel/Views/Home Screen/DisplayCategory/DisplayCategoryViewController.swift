//
//  DisplayCategoryViewController.swift
//  Tavel
//
//  Created by user245540 on 8/4/24.
//

import UIKit

class DisplayCategoryViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet var superView: UIView!
    @IBOutlet weak var topBarView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var CategoryNameLabel: UILabel!
    let categories:[CategoriesModel] = [
        CategoriesModel(imageView: "Angkor1", title: "Angkor Wat Tample", detail: "Angkor is one of the most important archaeological sites in South-East Asia. Stretching over some 400 km2, including forested area, Angkor Archaeological Park contains the magnificent remains of the different capitals of the Khmer Empire, from the 9th to the 15th century. They include the famous Temple of Angkor Wat and, at Angkor Thom, the Bayon Temple with its countless sculptural decorations. UNESCO has set up a wide-ranging programme to safeguard this symbolic site and its surroundings.", location: " Siem Reap"),
        CategoriesModel(imageView: "Angkor1", title: "Angkor Wat Tample", detail: "Angkor is one of the most important archaeological sites in South-East Asia. Stretching over some 400 km2, including forested area, Angkor Archaeological Park contains the magnificent remains of the different capitals of the Khmer Empire, from the 9th to the 15th century. They include the famous Temple of Angkor Wat and, at Angkor Thom, the Bayon Temple with its countless sculptural decorations. UNESCO has set up a wide-ranging programme to safeguard this symbolic site and its surroundings.", location: " Siem Reap"),
        CategoriesModel(imageView: "Angkor1", title: "Angkor Wat Tample", detail: "Angkor is one of the most important archaeological sites in South-East Asia. Stretching over some 400 km2, including forested area, Angkor Archaeological Park contains the magnificent remains of the different capitals of the Khmer Empire, from the 9th to the 15th century. They include the famous Temple of Angkor Wat and, at Angkor Thom, the Bayon Temple with its countless sculptural decorations. UNESCO has set up a wide-ranging programme to safeguard this symbolic site and its surroundings.", location: " Siem Reap"),
        CategoriesModel(imageView: "Angkor1", title: "Angkor Wat Tample", detail: "Angkor is one of the most important archaeological sites in South-East Asia. Stretching over some 400 km2, including forested area, Angkor Archaeological Park contains the magnificent remains of the different capitals of the Khmer Empire, from the 9th to the 15th century. They include the famous Temple of Angkor Wat and, at Angkor Thom, the Bayon Temple with its countless sculptural decorations. UNESCO has set up a wide-ranging programme to safeguard this symbolic site and its surroundings.", location: " Siem Reap"),
        CategoriesModel(imageView: "Angkor1", title: "Angkor Wat Tample", detail: "Angkor is one of the most important archaeological sites in South-East Asia. Stretching over some 400 km2, including forested area, Angkor Archaeological Park contains the magnificent remains of the different capitals of the Khmer Empire, from the 9th to the 15th century. They include the famous Temple of Angkor Wat and, at Angkor Thom, the Bayon Temple with its countless sculptural decorations. UNESCO has set up a wide-ranging programme to safeguard this symbolic site and its surroundings.", location: " Siem Reap"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        collectionView.dataSource = self
        collectionView.delegate = self
        let nib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
      
    }
    func setupView(){
        // super view
        superView.backgroundColor = UIColor(hex: "CDE8E5")
        // main View
        mainView.backgroundColor = UIColor(hex: "CDE8E5")
        // button
        closeBtn.setTitle("", for: .normal)
        // scrollView
        
        collectionView.backgroundColor = .clear
        
    }
    
    @IBAction func closebtnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension DisplayCategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        let category = categories[indexPath.item]
        if let imageName = category.imageView {
            cell.imageView.image = UIImage(named: imageName)
        }
        cell.titleLabel.text = category.title
        cell.descriptionLabel.text = category.detail
        cell.LocationLabel.text = category.location
        
        return cell
    }
    
    
}
