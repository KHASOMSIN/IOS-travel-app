//import UIKit
//
//class PopularDetailViewController: UIViewController, UIScrollViewDelegate  {
//    
//    var scrollView: UIScrollView!
//    var stretchyHeaderView: StretchyTableHeaderView!
//    var viewContainer: UIView!
//    var placeNameLbl: UILabel!
//    var shareBtn: UIButton!
//    var locationLabel: UILabel!
//    var locationIcon: UIImageView!
//    var overviewView: UIView!
//    var detailView: UIView!
//    var reviewView: UIView!
//    var locationView: UIView!
//    var descriptionLbl: UILabel!
//    var descriptionTextLbl: UILabel!
//    var letStarttripLabel: UILabel!
//    var tripStartCollectionView: UICollectionView!
//    let tripLayoutView = UICollectionViewFlowLayout()
//    
//    let trip: [TripModel] = [
//        TripModel(title: "Adtrip", imageName: "Ticket Star"),
//        TripModel(title: "Hotel", imageName: "Ticket Star"),
//        TripModel(title: "Passenger", imageName: "Ticket Star"),
//    ]
//    
//    let customSegmentedControl: CustomSegmentedControl = {
//        let control = CustomSegmentedControl(frame: .zero, buttonTitles: ["Overview", "Detail", "Review","Location"])
//        control.translatesAutoresizingMaskIntoConstraints = false
//        control.textColor = .black
//        control.selectorTextColor = .red
//        return control
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        createViews()
//        setViewConstraints()
//        setupCustomBackButton()
//        
//        
//        viewContainer.addSubview(customSegmentedControl)
//        customSegmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
//        
//        // Show the first view by default
//        segmentChanged(sender: customSegmentedControl)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        // Make sure the top constraint of the TableView is equal to Superview and not Safe Area
//        
//        // Hide the navigation bar completely
//        //self.navigationController?.setNavigationBarHidden(true, animated: false)
//        
//        
//        // Make the Navigation Bar background transparent
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.tintColor = .white
//        
//        // Remove 'Back' text and Title from Navigation Bar
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        self.title = ""
//    }
//    
//    
//    @objc func segmentChanged(sender: CustomSegmentedControl) {
//        print("Selected segment index: \(sender.selectedSegmentIndex)")
//        
//        overviewView.isHidden = true
//        detailView.isHidden = true
//        reviewView.isHidden = true
//        locationView.isHidden = true
//        
//        switch sender.selectedSegmentIndex {
//        case 0:
//            overviewView.isHidden = false
//        case 1:
//            detailView.isHidden = false
//        case 2:
//            reviewView.isHidden = false
//        case 3:
//            locationView.isHidden = false
//        default:
//            break
//        }
//    }
//    // MARK: create collection view
//    
//    func createViews() {
//        
//        scrollView = UIScrollView()
//        scrollView.delegate = self
//        view.addSubview(scrollView)
//        
//        // Initialize and add StretchyTableHeaderView
//        stretchyHeaderView = StretchyTableHeaderView()
//        stretchyHeaderView.imageView.image = UIImage(named: "Angkor1") // Set image
//        scrollView.addSubview(stretchyHeaderView)
//        
//        // View Container
//        viewContainer = UIView()
//        viewContainer.backgroundColor = .white
//        viewContainer.layer.cornerRadius = 30
//        viewContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        scrollView.addSubview(viewContainer)
//        
//        // Name of place
//        placeNameLbl = UILabel()
//        placeNameLbl.text = "Angkor Wat temple in Cambodia"
//        placeNameLbl.numberOfLines = 0
//        placeNameLbl.font = UIFont.boldSystemFont(ofSize: 20)
//        viewContainer.addSubview(placeNameLbl)
//        
//        // Initialize and customize share button
//        shareBtn = UIButton(type: .system)
//        shareBtn.layer.borderWidth = 0.6
//        shareBtn.layer.borderColor = UIColor.gray.cgColor
//        shareBtn.layer.cornerRadius = 15
//        customizeButton()
//        viewContainer.addSubview(shareBtn)
//        
//        // location label
//        locationLabel = UILabel()
//        locationLabel.font = UIFont.systemFont(ofSize: 15)
//        locationLabel.text = "Kompong Speu"
//        locationLabel.tintColor = .gray
//        viewContainer.addSubview(locationLabel)
//        
//        // location icon
//        locationIcon = UIImageView()
//        locationIcon.image = UIImage(named: "Location")
//        viewContainer.addSubview(locationIcon)
//        
//        // Overview UIView
//        overviewView = UIView()
//        overviewView.backgroundColor = .white
//        viewContainer.addSubview(overviewView)
//        
//        // OVerview Descriptions
//        descriptionLbl = UILabel()
//        descriptionLbl.text = "Description"
//        descriptionLbl.font = UIFont.boldSystemFont(ofSize: 20)
//        descriptionLbl.textAlignment = .left
//        overviewView.addSubview(descriptionLbl)
//        
//        // overview textLabel
//        descriptionTextLbl = UILabel()
//        descriptionTextLbl.numberOfLines = 0
//        descriptionTextLbl.textAlignment = .left
//        descriptionTextLbl.text = "   Museum focusing on local indigenous people & culture, with all tools, clothing & artifacts on display. Don bosco to museum."
//        descriptionTextLbl.setLineSpacing(lineSpacing: 8.0)
//        descriptionTextLbl.font = UIFont.systemFont(ofSize: 13)
//        
//        descriptionTextLbl.textColor = UIColor(hex: "686D76")
//        overviewView.addSubview(descriptionTextLbl)
//        
//        letStarttripLabel = UILabel()
//        letStarttripLabel.text = "Let's Start Your Trip"
//        letStarttripLabel.font = UIFont.boldSystemFont(ofSize: 20)
//        letStarttripLabel.textAlignment = .left
//        overviewView.addSubview(letStarttripLabel)
//        
//        
//        // Detail UIView
//        detailView = UIView()
//        detailView.backgroundColor = .green
//        viewContainer.addSubview(detailView)
//        
//        // Review UIView
//        reviewView = UIView()
//        reviewView.backgroundColor = .yellow
//        viewContainer.addSubview(reviewView)
//        
//        // Location UIView
//        locationView = UIView()
//        locationView.backgroundColor = .purple
//        viewContainer.addSubview(locationView)
//        
//        // Initially hide all views except overviewView
//        detailView.isHidden = true
//        reviewView.isHidden = true
//        locationView.isHidden = true
//    }
//    
//    func setViewConstraints() {
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//        
//        stretchyHeaderView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            stretchyHeaderView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            stretchyHeaderView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            stretchyHeaderView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            stretchyHeaderView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//            stretchyHeaderView.heightAnchor.constraint(equalToConstant: 334) // Set the initial height
//        ])
//        
//        viewContainer.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            viewContainer.topAnchor.constraint(equalTo: stretchyHeaderView.bottomAnchor, constant: -30),
//            viewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            viewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            viewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            viewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//            viewContainer.heightAnchor.constraint(equalToConstant: 600) // Adjust as needed
//        ])
//        
//        // Stack View for name label and share button
//        let nameAndSharebtnStackView = UIStackView(arrangedSubviews: [placeNameLbl, shareBtn])
//        nameAndSharebtnStackView.axis = .horizontal
//        nameAndSharebtnStackView.spacing = 10
//        nameAndSharebtnStackView.alignment = .center
//        nameAndSharebtnStackView.distribution = .fill
//        
//        viewContainer.addSubview(nameAndSharebtnStackView)
//        nameAndSharebtnStackView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            nameAndSharebtnStackView.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 20),
//            nameAndSharebtnStackView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 20),
//            nameAndSharebtnStackView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20),
//            
//            placeNameLbl.topAnchor.constraint(equalTo: nameAndSharebtnStackView.topAnchor),
//            placeNameLbl.leadingAnchor.constraint(equalTo: nameAndSharebtnStackView.leadingAnchor),
//            
//            shareBtn.topAnchor.constraint(equalTo: nameAndSharebtnStackView.topAnchor),
//            shareBtn.trailingAnchor.constraint(equalTo: nameAndSharebtnStackView.trailingAnchor),
//            shareBtn.widthAnchor.constraint(equalToConstant: 80),
//            shareBtn.heightAnchor.constraint(equalToConstant: 30)
//        ])
//        
//        // Stack View for location image and label
//        let locationStackView = UIStackView(arrangedSubviews: [locationIcon, locationLabel])
//        locationStackView.axis = .horizontal
//        locationStackView.spacing = 10
//        locationStackView.alignment = .center
//        locationStackView.distribution = .fill
//        viewContainer.addSubview(locationStackView)
//        
//        locationStackView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            locationStackView.topAnchor.constraint(equalTo: nameAndSharebtnStackView.bottomAnchor, constant: 8),
//            locationStackView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 20),
//            locationStackView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20),
//            
//            locationIcon.widthAnchor.constraint(equalToConstant: 20),
//            locationIcon.heightAnchor.constraint(equalToConstant: 20)
//        ])
//        
//        // Constraints for custom segmented control
//        viewContainer.addSubview(customSegmentedControl)
//        NSLayoutConstraint.activate([
//            customSegmentedControl.topAnchor.constraint(equalTo: locationStackView.bottomAnchor, constant: 5),
//            customSegmentedControl.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 20),
//            customSegmentedControl.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20),
//            customSegmentedControl.heightAnchor.constraint(equalToConstant: 40)
//        ])
//        
//        // Constraints for overview view
//        overviewView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            overviewView.topAnchor.constraint(equalTo: customSegmentedControl.bottomAnchor, constant: 10),
//            overviewView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 20),
//            overviewView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20),
//            overviewView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -10)
//        ])
//        
//        // Constraints for detail view
//        detailView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            detailView.topAnchor.constraint(equalTo: customSegmentedControl.bottomAnchor, constant: 10),
//            detailView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 20),
//            detailView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20),
//            detailView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -10)
//        ])
//        
//        // Constraints for review view
//        reviewView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            reviewView.topAnchor.constraint(equalTo: customSegmentedControl.bottomAnchor, constant: 10),
//            reviewView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 20),
//            reviewView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20),
//            reviewView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -10)
//        ])
//        
//        // Constraints for location view
//        locationView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            locationView.topAnchor.constraint(equalTo: customSegmentedControl.bottomAnchor, constant: 10),
//            locationView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 20),
//            locationView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20),
//            locationView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -10)
//        ])
//        
//        // overview constraint  =
//        // Stack View for overview
//        let descriptionStackView = UIStackView(arrangedSubviews: [descriptionLbl, descriptionTextLbl])
//        descriptionStackView.axis = .vertical
//        descriptionStackView.spacing = 10
//        descriptionStackView.alignment = .leading
//        descriptionStackView.distribution = .fill
//        overviewView.addSubview(descriptionStackView)
//        descriptionStackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            
//            descriptionStackView.topAnchor.constraint(equalTo: overviewView.topAnchor, constant: 10),
//            descriptionStackView.trailingAnchor.constraint(equalTo: overviewView.trailingAnchor),
//            descriptionStackView.leadingAnchor.constraint(equalTo: overviewView.leadingAnchor),
//            descriptionStackView.bottomAnchor.constraint(equalTo: descriptionTextLbl.bottomAnchor)
//        ])
//        
//        // label for let's trip
//        letStarttripLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            letStarttripLabel.leadingAnchor.constraint(equalTo: overviewView.leadingAnchor),
//            letStarttripLabel.topAnchor.constraint(equalTo: descriptionStackView.bottomAnchor, constant: 10),
//            letStarttripLabel.trailingAnchor.constraint(equalTo: overviewView.trailingAnchor)
//        ])
//        
//        
//    }
//    
//    private func customizeButton() {
//        // Set the button image
//        if let buttonImage = UIImage(named: "share") {
//            let resizedImage = ImageResizer.resizeImage(image: buttonImage, targetSize: CGSize(width: 20, height: 20))
//            shareBtn.setImage(resizedImage, for: .normal)
//        }
//        
//        shareBtn.setTitle("Share", for: .normal)
//        shareBtn.setTitleColor(.black, for: .normal) // Customize title color
//        shareBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
//        
//        shareBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
//        shareBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
//    }
//    
//    @objc func backButtonTapped() {
//        navigationController?.popViewController(animated: true)
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        stretchyHeaderView.scrollViewDidScroll(scrollView: scrollView)
//    }
//    
//    func setupCustomBackButton() {
//        let backButton = UIButton(type: .system)
//        backButton.setImage(UIImage(named: "custom_back_icon"), for: .normal)
//        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
//        
//        let backButtonItem = UIBarButtonItem(customView: backButton)
//        navigationItem.leftBarButtonItem = backButtonItem
//    }
//}
//
////
