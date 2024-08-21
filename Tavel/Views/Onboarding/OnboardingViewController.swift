//
//  OnboardingViewController.swift
//  Tavel
//
//  Created by user245540 on 7/8/24.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var nextTapped: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var slides:[OnboardingSlides] = []
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextTapped.setTitle("Get Started", for: .normal)
            }else{
                nextTapped.setTitle("Next", for: .normal)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        pageControl.isUserInteractionEnabled = false
        
        slides = [
            OnboardingSlides(title: "Add & Manage Cards", decsr: "Manage your all earnings, expenses & every penny anyhere, anytime", images: UIImage(named: "Onboarding 1")),
            OnboardingSlides(title: "Transfer & Receive Money", decsr: "Manage your all earnings, expenses & every penny anyhere, anytime", images: UIImage(named: "Onboarding 2")),
            OnboardingSlides(title: "Pay Bills & Payments", decsr: "Manage your all earnings, expenses & every penny anyhere, anytime", images: UIImage(named: "Onboarding 3"))
        ]

    }
    
    @IBAction func nextBtnClick(_ sender: UIButton) {
        if currentPage == slides.count - 1 {
            print("login screen")
            let viewController = LoginViewController()
            viewController.modalPresentationStyle = .fullScreen
            viewController.modalTransitionStyle = .crossDissolve
            present(viewController, animated: true)
        }else{
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = collectionView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    
    }
}