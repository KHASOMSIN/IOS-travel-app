import UIKit
import SnapKit
import MapKit
import CoreLocation
import Alamofire

class ProvinceDetailViewController: UIViewController, UIScrollViewDelegate, UISearchBarDelegate  {
    
    var scrollView: UIScrollView!
    var firstView: UIView!
    var imageView: UIImageView!
    var viewContainer: UIView!
    var placeNameLbl: UILabel!
    var shareBtn: UIButton!
    var locationLabel: UILabel!
    var locationIcon: UIImageView!
    var overviewView: UIView!
    var placeView: UIView!
    var reviewView: UIView!
    var locationView: UIView!
    var descriptionLbl: UILabel!
    var descriptionTextLbl: UILabel!
    var letStarttripLabel: UILabel!
    var tripStartCollectionView: UICollectionView!
    let tripLayoutView = UICollectionViewFlowLayout()
    var categoryCollectionView: UICollectionView!
    let categoryLayout = UICollectionViewFlowLayout()
    var placeCollectionView: UICollectionView!
    let placeLayoutView = UICollectionViewFlowLayout()
    var reviewCollectionView: UICollectionView!
    let reviewLayoutVIew = UICollectionViewFlowLayout()
    var mapView = MKMapView()
    var locationManager = CLLocationManager()
    var destinationCoordinate: CLLocationCoordinate2D?
    let kilometers = UILabel()
    let Estimated  = UILabel()
    
    
    var provincId: Int?
    var provinceImages: [ProvinceImage] = []
    
    var locations: [Location] = []
    var targetProvinceId = 0
  
    var latitude: CLLocationDegrees = 0
    var longitude: CLLocationDegrees = 0
    var longLabel = UILabel()
    var latLabel = UILabel()
    
    let searchTextField = CustomTextField()
    var isSearching = false
    
    let reviewPresentation = HalfModalTransitioningDelegate()
    var galleryCollectionViewHeightConstraint: NSLayoutConstraint!
    
    private var category: [Category] = []
    private var place: [Pupular] = []
    
    let rate:[ReviewModel] = [
        ReviewModel(profileImageName: "AccountProfiles", name: "Kha Sin", rating: 5, createdDate: "20/20/2001", reviewDetail: "Angkor is one of the most important archaeological sites in South-East Asia. Stretching over some 400 km2, including forested area, Angkor Archaeological"),
        ReviewModel(profileImageName: "AccountProfiles", name: "Kha Sin", rating: 5, createdDate: "20/20/2001", reviewDetail: "Angkor is one of the most important archaeological sites in South-East Asia. Stretching over some 400 km2, including forested area, Angkor Archaeological"),
    ]
    let customSegmentedControl: CustomSegmentedControl = {
        let control = CustomSegmentedControl(frame: .zero, buttonTitles: ["Overview", "Places", "Review","Location"])
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
        setupforOvervieew()
        setupPlace()
        setupReview()
        setupLocationView()
                
        setupLocationManager() //check user curren Location
        
        setupCollectionView(tripStartCollectionView)
        setupCollectionView(categoryCollectionView)
        setupCollectionView(placeCollectionView)
        setupCollectionView(reviewCollectionView)
        
        
        
        viewContainer.addSubview(customSegmentedControl)
        customSegmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        // Show the first view by default
        segmentChanged(sender: customSegmentedControl)
        
        if let id = provincId {
            fetchProvinceImages(for: id)
            targetProvinceId = id
            fetchLocation(provinceId: id)
            fetchAndDisplayProvinceData(by: id)
            fetchCategories(for: id)
            fetchPlaces(for: id)
            
        }
    }

    func fetchPlaces(for provinceId: Int) {
        let url = "\(urlTravel)travel/places/byprovince/\(provinceId)" // Update with the correct endpoint

        AF.request(url).responseDecodable(of: [Pupular].self) { response in
            switch response.result {
            case .success(let places):
                self.place = places
                DispatchQueue.main.async {
                    self.placeCollectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching places: \(error)")
            }
        }
    }

    
    func fetchCategories(for provinceId: Int) {
        let url = "\(urlLocal)travel/categories/province/\(provinceId)"
        
        AF.request(url).responseDecodable(of: CategoriesResponse.self) { response in
            switch response.result {
            case .success(let categoriesResponse):
                self.category = categoriesResponse.categories
                DispatchQueue.main.async {
                    self.categoryCollectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching categories: \(error)")
            }
        }
    }

    private func fetchAndDisplayProvinceData(by id: Int) {
         fetchProvinceData(by: id) { [weak self] result in
             switch result {
             case .success(let province):
                 self?.updateUI(with: province)
             case .failure(let error):
                 print("Error fetching province data: \(error.localizedDescription)")
                 // Optionally, display an alert or error message to the user
             }
         }
     }
     
     private func updateUI(with province: Province) {
         placeNameLbl.text = province.detailTitle
         descriptionTextLbl.text = province.description
         
         if let urlString = province.galleryPhotos, let url = URL(string: urlString) {
             // Use Kingfisher to load the image
             imageView.kf.setImage(with: url) { result in
                 switch result {
                 case .success(let value):
                     print("Image loaded successfully")
                     self.imageView.image = value.image
                 case .failure(let error):
                     print("Error loading image: \(error.localizedDescription)")
                     // Handle the error (e.g., show a placeholder image)
                     self.imageView.image = UIImage(named: "placeholder") // Set a placeholder image
                 }
             }
         } else {
             // Handle the case where galleryPhotos is nil or invalid
             self.imageView.image = UIImage(named: "placeholder") // Set a placeholder image
         }
     }

    @IBAction func mapViewTapped() {
         guard let latitude = destinationCoordinate?.latitude,
               let longitude = destinationCoordinate?.longitude else {
             print("Destination coordinates are not set.")
             return
         }
         
         let urlString = "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving"
         if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
         } else {
             // Fallback to Apple Maps if Google Maps is not installed
             let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
             let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
             mapItem.name = locationLabel.text
             mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
         }
     }
     
     func fetchLocation(provinceId: Int) {
         let apiUrl = "\(urlTravel)/travel/locations/province/\(provinceId)"
         
         AF.request(apiUrl, method: .get).responseDecodable(of: [Location].self) { response in
             switch response.result {
             case .success(let locations):
                 if let location = locations.first {
                     self.handleLocation(location)
                     self.locationLabel.text = "\(location.locationName)"
                     self.navigationItem.title = "\(location.locationName)"
                 }
             case .failure(let error):
                 print("Error fetching location: \(error.localizedDescription)")
             }
         }
     }
     
     private func handleLocation(_ location: Location) {
         guard let latitude = Double(location.latitude),
               let longitude = Double(location.longitude) else {
             print("Invalid latitude or longitude")
             return
         }
         
         destinationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
         displayLocationOnMap(latitude: latitude, longitude: longitude, name: location.locationName)
         calculateAndDisplayDistanceAndTime()
     }
     
     private func displayLocationOnMap(latitude: Double, longitude: Double, name: String) {
         let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
         let annotation = MKPointAnnotation()
         annotation.coordinate = coordinate
         annotation.title = name
         
         mapView.addAnnotation(annotation)
         
         let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
         mapView.setRegion(region, animated: true)
     }
     
     private func setupLocationManager() {
         locationManager = CLLocationManager()
         locationManager.delegate = self
         locationManager.requestWhenInUseAuthorization()
         locationManager.startUpdatingLocation()
     }


    func fetchProvinceImages(for id: Int) {
        APIManager.shared.fetchProvinceImages(for: id) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let images):
                        self?.provinceImages = images
                        self?.tripStartCollectionView.reloadData()
                    case .failure(let error):
                        self?.showError(error)
                    }
                }
            }
        } 
    

    
    func showError(_ error: APIError) {
         let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         present(alert, animated: true, completion: nil)
    }

    
    func setupCollectionView (_ collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCustomBackButton()
    }
    override func viewDidAppear(_ animated: Bool) {
        setupCustomBackButton()
    }
    override func viewWillDisappear(_ animated: Bool) {
        setupCustomBackButton()
    }
    
    @objc func segmentChanged(sender: CustomSegmentedControl) {
        print("Selected segment index: \(sender.selectedSegmentIndex)")
        
        // Hide all views initially and set their alpha to 0 for fade-out effect
        overviewView.alpha = 0
        placeView.alpha = 0
        reviewView.alpha = 0
        locationView.alpha = 0
        
        switch sender.selectedSegmentIndex {
        case 0:
            overviewView.isHidden = false
        case 1:
            placeView.isHidden = false
        case 2:
            reviewView.isHidden = false
        case 3:
            locationView.isHidden = false
        default:
            break
        }
    
        UIView.animate(withDuration: 0.1, animations: {
            // Animate the layout changes
            self.view.layoutIfNeeded()
            
            // Animate the alpha value to fade-in the selected view
            switch sender.selectedSegmentIndex {
            case 0:
                self.overviewView.alpha = 1
                self.overviewView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            case 1:
                self.placeView.alpha = 1
                self.placeView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
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
                self.placeView.transform = .identity
                self.reviewView.transform = .identity
                self.locationView.transform = .identity
            }
        }
//        updateCollectionViewHeight()
    }
    // MARK: create collection view
    
    func createViews() {

        
        view.backgroundColor = .white
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchTextField)
        searchTextField.font = UIFont.systemFont(ofSize: 13)
        searchTextField.backgroundColor = .white
        searchTextField.layer.cornerRadius = 25
        searchTextField.placeholder = "Discover a place"
        searchTextField.setupLeftIcon(UIImage(named: "search"))
        searchTextField.isHidden = true
        searchTextField.addShadow()
        
        
        firstView = UIView()
        scrollView.addSubview(firstView)
        
        imageView = UIImageView()
        firstView.addSubview(imageView)
//        imageView.image = UIImage(named: "battambang")
        imageView.contentMode = .scaleAspectFill
        
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
        customizeButton()
        shareBtn.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        viewContainer.addSubview(shareBtn)
        
        // location label
        locationLabel = UILabel()
        locationLabel.font = UIFont.systemFont(ofSize: 15)
//        locationLabel.text = locationLabel.text
        locationLabel.tintColor = .gray
        viewContainer.addSubview(locationLabel)
        
        // location icon
        locationIcon = UIImageView()
        locationIcon.image = UIImage(named: "Location")
        viewContainer.addSubview(locationIcon)
    
        
        
        // Detail UIView
        placeView = UIView()
        placeView.backgroundColor = .white
        viewContainer.addSubview(placeView)
        
        // Review UIView
        reviewView = UIView()
        reviewView.backgroundColor = .white
        viewContainer.addSubview(reviewView)
        
        // Location UIView
        locationView = UIView()
        locationView.backgroundColor = .white
        viewContainer.addSubview(locationView)
        
        // Initially hide all views except overviewView
        placeView.isHidden = true
        reviewView.isHidden = true
        locationView.isHidden = true
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
    
    func setViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 5),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
               
        firstView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            firstView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            firstView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            firstView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            firstView.heightAnchor.constraint(equalToConstant: 373.5) // Set the initial height
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: firstView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: firstView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: firstView.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: firstView.trailingAnchor)
        ])
        
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: firstView.bottomAnchor, constant: -30),
            viewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            viewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            viewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            viewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            viewContainer.heightAnchor.constraint(equalToConstant: 850) // Adjust as needed
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
        
        // Constraints for detail view
        placeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeView.topAnchor.constraint(equalTo: customSegmentedControl.bottomAnchor, constant: 10),
            placeView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 20),
            placeView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20),
            placeView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -10)
        ])
        
        // Constraints for review view
        reviewView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            reviewView.topAnchor.constraint(equalTo: customSegmentedControl.bottomAnchor, constant: 10),
            reviewView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 20),
            reviewView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20),
            reviewView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -10)
        ])
        // Constraints for location view
        locationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationView.topAnchor.constraint(equalTo: customSegmentedControl.bottomAnchor, constant: 10),
            locationView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 20),
            locationView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20),
            locationView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -10)
        ])
    }
    // set  up overview
    func setupforOvervieew (){

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
        
        descriptionTextLbl.setLineSpacing(lineSpacing: 7.0)
        descriptionTextLbl.font = UIFont.systemFont(ofSize: 13)
        
        descriptionTextLbl.textColor = UIColor(hex: "686D76")
        overviewView.addSubview(descriptionTextLbl)
        
        letStarttripLabel = UILabel()
        letStarttripLabel.text = "Gallery Photos"
        letStarttripLabel.font = UIFont.boldSystemFont(ofSize: 20)
        letStarttripLabel.textAlignment = .left
        overviewView.addSubview(letStarttripLabel)
        
        // overview constraint  =
        
        
        // Constraints for overview view
        overviewView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overviewView.topAnchor.constraint(equalTo: customSegmentedControl.bottomAnchor, constant: 10),
            overviewView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 20),
            overviewView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20),
            overviewView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -10)
        ])
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
            letStarttripLabel.topAnchor.constraint(equalTo: descriptionStackView.bottomAnchor, constant: 10),
            letStarttripLabel.trailingAnchor.constraint(equalTo: overviewView.trailingAnchor)
        ])
        
        // MARK: CollectionView
        // Setup the galleryCollectionView
        tripLayoutView.minimumLineSpacing = 10
        tripLayoutView.scrollDirection = .horizontal
        tripStartCollectionView = UICollectionView(frame: .zero, collectionViewLayout: tripLayoutView)
        tripStartCollectionView.register(ProvincesGalleryCollectionViewCell.self, forCellWithReuseIdentifier: "ProvincesGalleryCollectionViewCell")
        tripStartCollectionView.showsVerticalScrollIndicator = false
        tripStartCollectionView.showsHorizontalScrollIndicator = false
        overviewView.addSubview(tripStartCollectionView)
        
            
        tripStartCollectionView.translatesAutoresizingMaskIntoConstraints = false
        galleryCollectionViewHeightConstraint = tripStartCollectionView.heightAnchor.constraint(equalToConstant: 0)
                
        NSLayoutConstraint.activate([
            tripStartCollectionView.topAnchor.constraint(equalTo: letStarttripLabel.bottomAnchor, constant: 10),
            tripStartCollectionView.leadingAnchor.constraint(equalTo: overviewView.leadingAnchor),
            tripStartCollectionView.trailingAnchor.constraint(equalTo: overviewView.trailingAnchor),
            tripStartCollectionView.bottomAnchor.constraint(equalTo: overviewView.bottomAnchor),
        ])
        
    }
    
    // set up for places
    func setupPlace(){
        let categoryLabel = UILabel()
        placeView.addSubview(categoryLabel)
        categoryLabel.text = "Gategories"
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 20)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(placeView.snp.top).offset(10)
            make.leading.equalTo(placeView.snp.leading)
            make.trailing.equalTo(placeView.snp.trailing)
        }
        categoryLayout.minimumLineSpacing = 10
        categoryLayout.scrollDirection = .horizontal
        categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: categoryLayout)
        categoryCollectionView.register(ProvincesCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "ProvincesCategoryCollectionViewCell")
        placeView.addSubview(categoryCollectionView)
        
        // Set the constraints for categoryCollectionView using SnapKit
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(10)
            make.leading.equalTo(placeView.snp.leading)
            make.trailing.equalTo(placeView.snp.trailing)
            make.height.equalTo(200)
        }
        
        let ProvinceLabel = UILabel()
        ProvinceLabel.text = "Provinces Places"
        ProvinceLabel.font = UIFont.boldSystemFont(ofSize: 20)
        placeView.addSubview(ProvinceLabel)
        
        ProvinceLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(5)
            make.leading.equalTo(placeView.snp.leading)
            make.trailing.equalTo(placeView.snp.trailing)
        }
        
        placeLayoutView.minimumLineSpacing = 10
        placeLayoutView.scrollDirection = .horizontal
        placeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: placeLayoutView)
        placeCollectionView.register(PlacesCollectionViewCell.self, forCellWithReuseIdentifier: "PlacesCollectionViewCell")
        placeView.addSubview(placeCollectionView)
        
        // Set the constraints for categoryCollectionView using SnapKit
        placeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(ProvinceLabel.snp.bottom).offset(5)
            make.leading.equalTo(placeView.snp.leading)
            make.trailing.equalTo(placeView.snp.trailing)
            make.bottom.equalTo(placeView.snp.bottom).offset(-10)
        }

    }
    
    // setup review provinces
    private func setupReview(){
        
        let reviewLabel = UILabel()
        reviewLabel.text = "Review"
        reviewLabel.font = UIFont.boldSystemFont(ofSize: 20)
        reviewLabel.textAlignment = .left
        reviewView.addSubview(reviewLabel)
        
        let addReviewBtn = UIButton(type: .system)
        addReviewBtn.setTitle("Add Review", for: .normal)
        addReviewBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        addReviewBtn.tintColor = .blue
        addReviewBtn.addTarget(self, action: #selector(addReviewTapped), for: .touchUpInside)
        reviewView.addSubview(addReviewBtn)
        // Use the updated properties as needed
        reviewLayoutVIew.scrollDirection = .vertical
        reviewLayoutVIew.minimumLineSpacing = 10
        reviewLayoutVIew.minimumInteritemSpacing = 10
        
        reviewCollectionView = UICollectionView(frame: .zero, collectionViewLayout: reviewLayoutVIew)
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
    
    // setup location
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
            make.height.equalTo(400)
        }

    }
    
}

extension ProvinceDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tripStartCollectionView {
            return provinceImages.count
        } else if collectionView == categoryCollectionView {
            return category.count
        } else if collectionView == placeCollectionView {
            return place.count
        }else {
            return rate.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tripStartCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProvincesGalleryCollectionViewCell", for: indexPath) as! ProvincesGalleryCollectionViewCell
            let img = provinceImages[indexPath.item]
            cell.configure(with: img)
            return cell
        } else if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProvincesCategoryCollectionViewCell", for: indexPath) as! ProvincesCategoryCollectionViewCell
            let category = category[indexPath.item]
            cell.configure(with: category)
            return cell
        } else if collectionView == placeCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlacesCollectionViewCell", for: indexPath) as! PlacesCollectionViewCell
            let place = place[indexPath.item]
            
            cell.configure(with: place)
            
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewCollectionViewCell", for: indexPath) as! ReviewCollectionViewCell
            let review = rate[indexPath.item]
            cell.configure(with: review)
            return cell
        }
    }
}

extension ProvinceDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == placeCollectionView {
            let selected = place[indexPath.item]
            let detailViewController = PopularDetailViewController(selectedPlace: selected)
            detailViewController.selectedPlace? = selected
            navigationController?.pushViewController(detailViewController, animated: true)
        }
        
        print("selected")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tripStartCollectionView {
            return CGSize(width: collectionView.frame.width, height: 320)
        }else if collectionView == categoryCollectionView {
            return CGSize(width: 100, height: 150)
        }else if collectionView == placeCollectionView {
            return CGSize(width: 353, height: 320)
        } else {
            return CGSize(width: collectionView.frame.width, height: 130)
        }
    }
}

