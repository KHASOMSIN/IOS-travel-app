import UIKit
import MapKit
import CoreLocation

class PopularDetailViewController: UIViewController, UIScrollViewDelegate  {
    
    var scrollView: UIScrollView!
    var stretchyHeaderView: StretchyTableHeaderView!
    var viewContainer: UIView!
    var placeNameLbl: UILabel!
    var shareBtn: UIButton!
    var locationLabel: UILabel!
    var locationIcon: UIImageView!
    var overviewView: UIView!
    var detailView: UIView!
    var detailCaption: UILabel!
    var detailLabel: UILabel!
    var reviewView: UIView!
    var locationView: UIView!
    var descriptionLbl: UILabel!
    var descriptionTextLbl: UILabel!
    var letStarttripLabel: UILabel!
    var galleryCollectionView: UICollectionView!
    let tripLayoutView = UICollectionViewFlowLayout()
    var reviewCollectionView: UICollectionView!
    var revireLayoutView = UICollectionViewFlowLayout()
    var reviewLabel: UILabel!
    var addReviewBtn: UIButton!
    var mapView = MKMapView()
    let locationManager = CLLocationManager()
    let kilometers = UILabel()
    let Estimated  = UILabel()
    
    let latitude: CLLocationDegrees = 37.7770109
    let longitude: CLLocationDegrees = -122.3923233
    let locationame = "Kompong Speu"
    
    
    let reviewPresentation = HalfModalTransitioningDelegate()
    var galleryCollectionViewHeightConstraint: NSLayoutConstraint!
    
    let trip: [TripModel] = [
        TripModel( imageName: "Angkor1"),
        TripModel( imageName: "Angkor1"),
        TripModel( imageName: "Angkor1"),
    ]
    let rate: [ReviewModel] = [
        ReviewModel(profileImageName: "AccountProfiles", name: "KHA SIN", rating: 5, createdDate: "12/22/2001", reviewDetail: "This place is so good"),
    ]
    let customSegmentedControl: CustomSegmentedControl = {
        let control = CustomSegmentedControl(frame: .zero, buttonTitles: ["Overview", "Detail", "Review","Location"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.textColor = .black
        control.selectorTextColor = .red
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
        setViewConstraints()
        setupCustomBackButton()
        setupReview()
        setupLocationView()
//        showLocation()
        setupLocationManager()
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        
        viewContainer.addSubview(customSegmentedControl)
        customSegmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        // Show the first view by default
        segmentChanged(sender: customSegmentedControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .white
        
        // Remove 'Back' text and Title from Navigation Bar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = ""
    }
    
    
    @objc func segmentChanged(sender: CustomSegmentedControl) {
        print("Selected segment index: \(sender.selectedSegmentIndex)")
        
        // Hide all views initially and set their alpha to 0 for fade-out effect
        overviewView.alpha = 0
        detailView.alpha = 0
        reviewView.alpha = 0
        locationView.alpha = 0
        
        switch sender.selectedSegmentIndex {
        case 0:
            overviewView.isHidden = false
            galleryCollectionViewHeightConstraint.constant = view.bounds.height
            updateGalleryCollectionViewHeight()
        case 1:
            detailView.isHidden = false
            
        case 2:
            reviewView.isHidden = false
            galleryCollectionViewHeightConstraint.constant = view.bounds.height
        case 3:
            locationView.isHidden = false
            galleryCollectionViewHeightConstraint.constant = view.bounds.height
        default:
            break
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            // Animate the layout changes
            self.view.layoutIfNeeded()
            
            // Animate the alpha value to fade-in the selected view
            switch sender.selectedSegmentIndex {
            case 0:
                self.overviewView.alpha = 1
                self.overviewView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            case 1:
                self.detailView.alpha = 1
                self.detailView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            case 2:
                self.reviewView.alpha = 1
                self.reviewView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            case 3:
                self.locationView.alpha = 1
                self.locationView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            default:
                break
            }
        }) { _ in
            // Restore the scale transform to identity after animation
            UIView.animate(withDuration: 0.2) {
                self.overviewView.transform = .identity
                self.detailView.transform = .identity
                self.reviewView.transform = .identity
                self.locationView.transform = .identity
            }
        }
    }
    
    func createViews() {
        
        view.backgroundColor = .white
        scrollView = UIScrollView()
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        // Initialize and add StretchyTableHeaderView
        stretchyHeaderView = StretchyTableHeaderView()
        stretchyHeaderView.imageView.image = UIImage(named: "Angkor1") // Set image
        scrollView.addSubview(stretchyHeaderView)
        
        // View Container
        viewContainer = UIView()
        viewContainer.backgroundColor = .white
        viewContainer.layer.cornerRadius = 30
        viewContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        scrollView.addSubview(viewContainer)
        
        // Name of place
        placeNameLbl = UILabel()
        placeNameLbl.text = "Angkor Wat temple in Cambodia"
        placeNameLbl.numberOfLines = 0
        placeNameLbl.font = UIFont.boldSystemFont(ofSize: 20)
        viewContainer.addSubview(placeNameLbl)
        
        // Initialize and customize share button
        shareBtn = UIButton(type: .system)
        shareBtn.layer.borderWidth = 0.6
        shareBtn.layer.borderColor = UIColor.gray.cgColor
        shareBtn.layer.cornerRadius = 15
        shareBtn.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        customizeButton()
        viewContainer.addSubview(shareBtn)
        
        // location label
        locationLabel = UILabel()
        locationLabel.font = UIFont.systemFont(ofSize: 15)
        locationLabel.text = "Kompong Speu"
        locationLabel.tintColor = .gray
        viewContainer.addSubview(locationLabel)
        
        // location icon
        locationIcon = UIImageView()
        locationIcon.image = UIImage(named: "Location")
        viewContainer.addSubview(locationIcon)
        
        // Overview UIView
        overviewView = UIView()
        overviewView.backgroundColor = .white
        viewContainer.addSubview(overviewView)
        
        // OVerview Descriptions
        descriptionLbl = UILabel()
        descriptionLbl.text = "Description"
        descriptionLbl.font = UIFont.boldSystemFont(ofSize: 20)
        descriptionLbl.textAlignment = .left
        overviewView.addSubview(descriptionLbl)
        
        // overview textLabel
        descriptionTextLbl = UILabel()
        descriptionTextLbl.numberOfLines = 0
        descriptionTextLbl.textAlignment = .left
        descriptionTextLbl.text = "   Museum focusing on local indigenous people & culture, with all tools, clothing & artifacts on display. Don bosco to museum."
        //        descriptionTextLbl.setLineSpacing(lineSpacing: 8.0)
        descriptionTextLbl.font = UIFont.systemFont(ofSize: 13)
        
        descriptionTextLbl.textColor = UIColor(hex: "686D76")
        overviewView.addSubview(descriptionTextLbl)
        
        letStarttripLabel = UILabel()
        letStarttripLabel.text = "Gallery Photos"
        letStarttripLabel.font = UIFont.boldSystemFont(ofSize: 20)
        letStarttripLabel.textAlignment = .left
        overviewView.addSubview(letStarttripLabel)
        
        
        // Detail UIView
        detailView = UIView()
        detailView.backgroundColor = .white
        viewContainer.addSubview(detailView)
        
        // review label
        detailCaption = UILabel()
        detailView.addSubview(detailCaption)
        detailCaption.text = "Siemreap Angkor Wat Tample"
        detailCaption.font = UIFont.boldSystemFont(ofSize: 20)
        
        detailLabel  = UILabel()
        detailView.addSubview(detailLabel)
        detailLabel.font = UIFont.systemFont(ofSize: 13)
        detailLabel.textColor = .gray
        detailLabel.numberOfLines = 0
        detailLabel.text = "Angkor Wat, temple complex at Angkor, near Siem Reap, Cambodia, that was built in the 12th century by King Suryavarman II (reigned 1113–c. 1150) of the Khmer empire. The vast religious complex of Angkor Wat comprises more than a thousand buildings, and it is one of the great cultural wonders of the world. Angkor Wat is the world’s largest religious structure, covering some 400 acres (160 hectares), and marks the high point of Khmer architecture."
        
        
        // Review UIView
        reviewView = UIView()
        reviewView.backgroundColor = .white
        viewContainer.addSubview(reviewView)
        
        // Location UIView
        locationView = UIView()
        locationView.backgroundColor = .white
        
        viewContainer.addSubview(locationView)
        
        // Initially hide all views except overviewView
        detailView.isHidden = true
        reviewView.isHidden = true
        locationView.isHidden = true
    }
    
    func setViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        stretchyHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stretchyHeaderView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stretchyHeaderView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stretchyHeaderView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stretchyHeaderView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stretchyHeaderView.heightAnchor.constraint(equalToConstant: 334) // Set the initial height
        ])
        
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: stretchyHeaderView.bottomAnchor, constant: -30),
            viewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            viewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            viewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            viewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Stack View for name label and share button
        let nameAndSharebtnStackView = UIStackView(arrangedSubviews: [placeNameLbl, shareBtn])
        nameAndSharebtnStackView.axis = .horizontal
        nameAndSharebtnStackView.spacing = 10
        nameAndSharebtnStackView.alignment = .center
        nameAndSharebtnStackView.distribution = .fill
        
        viewContainer.addSubview(nameAndSharebtnStackView)
        nameAndSharebtnStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameAndSharebtnStackView.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 20),
            nameAndSharebtnStackView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 20),
            nameAndSharebtnStackView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20),
            
            placeNameLbl.topAnchor.constraint(equalTo: nameAndSharebtnStackView.topAnchor),
            placeNameLbl.leadingAnchor.constraint(equalTo: nameAndSharebtnStackView.leadingAnchor),
            
            shareBtn.topAnchor.constraint(equalTo: nameAndSharebtnStackView.topAnchor),
            shareBtn.trailingAnchor.constraint(equalTo: nameAndSharebtnStackView.trailingAnchor),
            shareBtn.widthAnchor.constraint(equalToConstant: 80),
            shareBtn.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Stack View for location image and label
        let locationStackView = UIStackView(arrangedSubviews: [locationIcon, locationLabel])
        locationStackView.axis = .horizontal
        locationStackView.spacing = 10
        locationStackView.alignment = .center
        locationStackView.distribution = .fill
        viewContainer.addSubview(locationStackView)
        
        locationStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationStackView.topAnchor.constraint(equalTo: nameAndSharebtnStackView.bottomAnchor, constant: 8),
            locationStackView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 20),
            locationStackView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20),
            
            locationIcon.widthAnchor.constraint(equalToConstant: 20),
            locationIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // Constraints for custom segmented control
        viewContainer.addSubview(customSegmentedControl)
        NSLayoutConstraint.activate([
            customSegmentedControl.topAnchor.constraint(equalTo: locationStackView.bottomAnchor, constant: 5),
            customSegmentedControl.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 20),
            customSegmentedControl.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20),
            customSegmentedControl.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Constraints for overview view
        overviewView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overviewView.topAnchor.constraint(equalTo: customSegmentedControl.bottomAnchor, constant: 10),
            overviewView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 20),
            overviewView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20),
            overviewView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -10)
        ])
        
        // MARK: Constraints for detail view
        detailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: customSegmentedControl.bottomAnchor, constant: 20),
            detailView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor)
        ])
        
        detailCaption.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailCaption.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 20),
            detailCaption.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 20),
            detailCaption.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -20)
        ])
        
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailLabel.topAnchor.constraint(equalTo: detailCaption.bottomAnchor, constant: 10),
            detailLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 20),
            detailLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -20)
        ])
        
        // Constraints for review view
        reviewView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            reviewView.topAnchor.constraint(equalTo: customSegmentedControl.bottomAnchor, constant: 10),
            reviewView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 20),
            reviewView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20),
            reviewView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor)
        ])
        
        // Constraints for location view
        locationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationView.topAnchor.constraint(equalTo: customSegmentedControl.bottomAnchor, constant: 10),
            locationView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 20),
            locationView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20),
            locationView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -10)
        ])
        
        // overview constraint  =
        // Stack View for overview
        let descriptionStackView = UIStackView(arrangedSubviews: [descriptionLbl, descriptionTextLbl])
        descriptionStackView.axis = .vertical
        descriptionStackView.spacing = 10
        descriptionStackView.alignment = .leading
        descriptionStackView.distribution = .fill
        overviewView.addSubview(descriptionStackView)
        descriptionStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            descriptionStackView.topAnchor.constraint(equalTo: overviewView.topAnchor, constant: 10),
            descriptionStackView.trailingAnchor.constraint(equalTo: overviewView.trailingAnchor),
            descriptionStackView.leadingAnchor.constraint(equalTo: overviewView.leadingAnchor),
            descriptionStackView.bottomAnchor.constraint(equalTo: descriptionTextLbl.bottomAnchor)
        ])
        
        // label for let's trip
        letStarttripLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            letStarttripLabel.leadingAnchor.constraint(equalTo: overviewView.leadingAnchor),
            letStarttripLabel.topAnchor.constraint(equalTo: descriptionStackView.bottomAnchor, constant: 25),
            letStarttripLabel.trailingAnchor.constraint(equalTo: overviewView.trailingAnchor)
        ])
        
        // MARK: CollectionView
        // Setup the galleryCollectionView
        tripLayoutView.minimumLineSpacing = 10
        tripLayoutView.scrollDirection = .horizontal
        galleryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: tripLayoutView)
        galleryCollectionView.register(TripCollectionViewCell.self, forCellWithReuseIdentifier: "TripCollectionViewCell")
        overviewView.addSubview(galleryCollectionView)
        
        
        galleryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        galleryCollectionViewHeightConstraint = galleryCollectionView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            galleryCollectionView.topAnchor.constraint(equalTo: letStarttripLabel.bottomAnchor, constant: 10),
            galleryCollectionView.leadingAnchor.constraint(equalTo: overviewView.leadingAnchor),
            galleryCollectionView.trailingAnchor.constraint(equalTo: overviewView.trailingAnchor),
            galleryCollectionView.bottomAnchor.constraint(equalTo: overviewView.bottomAnchor),
            galleryCollectionView.heightAnchor.constraint(equalToConstant: 350)
        ])
        
        
    }
    func setupReview() {
        reviewLabel = UILabel()
        reviewLabel.text = "Review"
        reviewLabel.font = UIFont.boldSystemFont(ofSize: 20)
        reviewLabel.textAlignment = .left
        reviewView.addSubview(reviewLabel)
        
        addReviewBtn = UIButton(type: .system)
        addReviewBtn.setTitle("Add Review", for: .normal)
        addReviewBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        addReviewBtn.tintColor = .blue
        addReviewBtn.addTarget(self, action: #selector(addReviewTapped), for: .touchUpInside)
        reviewView.addSubview(addReviewBtn)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        reviewCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        reviewCollectionView.backgroundColor = .white
        reviewCollectionView.delegate = self
        reviewCollectionView.dataSource = self
        reviewCollectionView.register(ReviewCollectionViewCell.self, forCellWithReuseIdentifier: "ReviewCollectionViewCell")
        reviewView.addSubview(reviewCollectionView)
        
        reviewLabel.translatesAutoresizingMaskIntoConstraints = false
        addReviewBtn.translatesAutoresizingMaskIntoConstraints = false
        reviewCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            reviewLabel.topAnchor.constraint(equalTo: reviewView.topAnchor, constant: 10),
            reviewLabel.leadingAnchor.constraint(equalTo: reviewView.leadingAnchor, constant: 20),
            
            addReviewBtn.centerYAnchor.constraint(equalTo: reviewLabel.centerYAnchor),
            addReviewBtn.trailingAnchor.constraint(equalTo: reviewView.trailingAnchor, constant: -20),
            
            reviewCollectionView.topAnchor.constraint(equalTo: reviewLabel.bottomAnchor, constant: 10),
            reviewCollectionView.leadingAnchor.constraint(equalTo: reviewView.leadingAnchor, constant: 20),
            reviewCollectionView.trailingAnchor.constraint(equalTo: reviewView.trailingAnchor, constant: -20),
            reviewCollectionView.bottomAnchor.constraint(equalTo: reviewView.bottomAnchor, constant: -10)
        ])
    }
    
    @objc func addReviewTapped() {
        // Navigate to add review screen
        print("Add Review Tapped")
        let viewController = AddReviewViewController()
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = reviewPresentation
        
        present(viewController, animated: true)
    }
    
    private func setupLocationView (){

        let titleLabel = UILabel()
        titleLabel.text = "LocationProvinces"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        locationView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {make in
            make.top.equalTo(locationView.snp.top).offset(10)
            make.left.equalTo(locationView.snp.left).offset(0)
            make.right.equalTo(locationView.snp.right).offset(0)
        }
        
        let icon1 = UIImageView()
        locationView.addSubview(icon1)
        icon1.image = UIImage(named: "kilometters")
        icon1.snp.makeConstraints {make in
            make.height.equalTo(24)
            make.width.equalTo(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
            make.left.equalTo(locationView.snp.left).offset(0)
        }
        locationView.addSubview(kilometers)
        kilometers.font = UIFont.systemFont(ofSize: 13)
        kilometers.snp.makeConstraints {make in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.left.equalTo(icon1.snp.right).offset(10)
            make.right.equalTo(locationView.snp.right).offset(0)
        }
    
        
        let icon2 = UIImageView()
        locationView.addSubview(icon2)
        icon2.image = UIImage(named: "estimate_time")
        icon2.snp.makeConstraints { make in
            make.top.equalTo(icon1.snp.bottom).offset(18)
            make.left.equalTo(locationView.snp.left).offset(0)
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        
        locationView.addSubview(Estimated)
        Estimated.font = UIFont.systemFont(ofSize: 13)
        Estimated.snp.makeConstraints {make in
            make.top.equalTo(kilometers.snp.bottom).offset(25)
            make.left.equalTo(icon2.snp.right).offset(10)
            make.right.equalTo(locationView.snp.right).offset(0)
        }
        
        mapView = MKMapView(frame: self.view.bounds)
        mapView.layer.cornerRadius = 10
        mapView.mapType = .satellite
        let guestureTapped = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
        mapView.addGestureRecognizer(guestureTapped)
        locationView.addSubview(mapView)
        
        mapView.snp.makeConstraints {make in
            make.top.equalTo(icon2.snp.bottom).offset(18)
            make.left.equalTo(locationView.snp.left).offset(0)
            make.right.equalTo(locationView.snp.right).offset(0)
            make.height.equalTo(340)
        }

    }
    
    
    private func customizeButton() {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        stretchyHeaderView.scrollViewDidScroll(scrollView: scrollView)
    }
    
    func setupCustomBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "custom_back_icon"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    
    @objc func shareTapped(){
        // Content to share
        let textToShare = "Check out this cool app!"
        let imageToShare = UIImage(named: "AppIcon") // Replace with your image
        let urlToShare = URL(string: "https://www.khasomsin.com") // Replace with your URL
        
        let itemsToShare: [Any] = [textToShare, imageToShare as Any, urlToShare as Any]
        
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)

        activityViewController.excludedActivityTypes = [.postToFacebook, .assignToContact, .saveToCameraRoll]
        
        // Present the activity view controller
        present(activityViewController, animated: true, completion: nil)
    }
}

extension PopularDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == galleryCollectionView {
            return trip.count
        }else {
            return rate.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == galleryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TripCollectionViewCell", for: indexPath) as! TripCollectionViewCell
            let trip = trip[indexPath.item]
            cell.configure(with: trip)
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewCollectionViewCell", for: indexPath) as! ReviewCollectionViewCell
            let rate = rate[indexPath.item]
            cell.configure(with: rate)
            return cell
        }
    }
}

extension PopularDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == galleryCollectionView {
            let width = (collectionView.frame.width)
            return CGSize(width: width, height: width - 150)
        } else {
            let width = collectionView.frame.width
            return CGSize(width: width, height: 130)
        }
    }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            // Handle cell tap if needed
        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            
        }
    

    func updateGalleryCollectionViewHeight() {
        let contentHeight = galleryCollectionView.collectionViewLayout.collectionViewContentSize.height
        galleryCollectionViewHeightConstraint.constant = contentHeight
    }

}


//extension PopularDetailViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let identifier = "CustomPinAnnotationView"
//        
//        if annotation is MKUserLocation {
//            return nil
//        }
//
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//        
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView?.canShowCallout = true
//        } else {
//            annotationView?.annotation = annotation
//        }
//        
//        // Set the custom pin image
//        annotationView?.image = UIImage(named: "Location") // Replace with your custom image name
//        
//        return annotationView
//    }
//}
