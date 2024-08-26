import UIKit
import CoreData
import SnapKit
import Localize_Swift
import Alamofire
class HomeViewController: UIViewController {
    
    // MARK: Properties
    
    let scrollView = UIScrollView()
    let mainView = UIView()
    let accountImages = UIImageView(image: UIImage(named: "AccountProfiles"))
    let notificationImage = UIImageView(image: UIImage(named: "notification_Cycles"))
    let accountNameLabel = UILabel()
    let welcomeLael = UILabel()
    let searchTextField = UITextField()
    let popularButton = UIButton()
    let mostViewButton = UIButton()
    let recomendedButton = UIButton()
    var popularCollectionView: UICollectionView!
    let firstMoreButton = UIButton()
    var provincesCollectionView: UICollectionView!
    let secondMoreButton = UIButton()
    let provincesLayout = CustomLayout()
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    let viewContainerPopulars = UIView()
    let viewContainerProvinces = UIView()
    let viewContainerCategory = UIView()
    var CategoriesCollectionView: UICollectionView!
    let categorieLayout = UICollectionViewFlowLayout()
    let layoutView = UICollectionViewFlowLayout()
    let categoriesButton = UIView()
    var stackViewFilter: UIStackView!
    
    var refreshControl = UIRefreshControl()
    
    var provinces: [ProvincesModel] = []
    var places: [Pupular] = []
    var categories: [Category] = []
    var itemWidth: CGFloat {
        return screenWidth * 0.4
    }
    
    var itemHeight: CGFloat {
        return itemWidth * 1.45
    }
    
    // MARK: - Initializer
    init() {
        provincesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: provincesLayout)
        super.init(nibName: nil, bundle: nil)
        provincesLayout.scrollDirection = .horizontal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "F3F2EC")
        setupCollectionView()
        setupUI()
        scrollView.delegate = self
        fetchProvincesData()
        updateWelcomeMessage()
        fetchPlaces()
        refreshData()
        setupRefreshControl()
        fetchCategories()
        
        APIClient.shared.fetchProvinces { provinces in
            if let provinces = provinces {
                // Use the provinces array here
                print("Provinces fetched: \(provinces)")
            } else {
                // Handle the error
                print("Failed to fetch provinces")
            }
        }
        
    }

    func fetchCategories() {
        let url = "\(urlLocal)travel/categories"
        
        AF.request(url).responseDecodable(of: CategoriesResponse.self) { response in
            switch response.result {
            case .success(let result):
                self.categories = result.categories
                self.CategoriesCollectionView.reloadData() // Reload collection view
            case .failure(let error):
                print("Failed to fetch categories: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }

    @objc private func refreshData() {
            // Fetch new data
        fetchPlaces()
        fetchProvincesData()
            
    }

    
    private func fetchPlaces() {
           APIPupular.shared.fetchPlaces { result in
               switch result {
               case .success(let places):
                   self.places = places
                   DispatchQueue.main.async {
                       self.popularCollectionView.reloadData()
                       self.refreshControl.endRefreshing()
                   }
               case .failure(let error):
                   print("Failed to fetch places: \(error)")
                   self.refreshControl.endRefreshing()
               }
           }
       }
    
    func fetchProvincesData() {
        APIClient.shared.fetchProvinces { [weak self] (fetchedProvinces) in
        guard let self = self, let provinces = fetchedProvinces else { return }
            self.provinces = provinces
            DispatchQueue.main.async {
                self.provincesCollectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Navigation Customization
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        // Remove 'Back' text and Title from Navigation Bar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Ensure the collection view has data before trying to scroll
        let numberOfItems = provincesCollectionView.numberOfItems(inSection: 0)
        let indexPath = IndexPath(item: 1, section: 0)
        
        if indexPath.item < numberOfItems {
            // Scroll to the item safely
            provincesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            // Update layout properties
            provincesLayout.currentPage = indexPath.item
            provincesLayout.previousOffset = provincesLayout.updateOffSet(provincesCollectionView)
            
            // Ensure the cell is visible before trying to transform it
            if let cell = provincesCollectionView.cellForItem(at: indexPath) {
                transformCell(cell)
            }
        } else {
            print("IndexPath item \(indexPath.item) is out of bounds. Number of items in section: \(numberOfItems)")
        }
        
        // Reload data for the popular collection view
        popularCollectionView.reloadData()
    }


    func setupCollectionView() {
        
        // for popular collectionView
       
        layoutView.itemSize = CGSize(width: view.bounds.width, height: view.bounds.width)
        layoutView.minimumLineSpacing = 0
        layoutView.minimumInteritemSpacing = 0
        layoutView.scrollDirection = .horizontal

        popularCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutView)
        popularCollectionView.register(FirstCollectionViewCell.self, forCellWithReuseIdentifier: "Cell1")
        popularCollectionView.isPagingEnabled = true
        setupCollectionView(popularCollectionView)
        
        // for provinces collectionView Constroller
        
//        let provincesLayout = UICollectionViewFlowLayout()
//        provincesLayout.itemSize = CGSize(width: 180, height: 250)
        provincesLayout.minimumLineSpacing = 50.0
        provincesLayout.minimumInteritemSpacing = 50.0
        provincesLayout.scrollDirection = .horizontal
        provincesLayout.itemSize.width = itemWidth
        provincesCollectionView.contentInsetAdjustmentBehavior = .never
        provincesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: provincesLayout)
        provincesCollectionView.contentInset = UIEdgeInsets(top: 0.0, left: 50, bottom: 0.0, right: 50)
        provincesCollectionView.decelerationRate = .fast
        provincesCollectionView.register(ProvincesCollectionViewCell.self, forCellWithReuseIdentifier: "Cell2")
        setupCollectionView(provincesCollectionView)
    }
    private func updateWelcomeMessage() {
            let hour = Calendar.current.component(.hour, from: Date())
            var welcomeText = ""
            
            switch hour {
            case 6..<12:
                welcomeText = "Good Morning!".localized()
            case 12..<18:
                welcomeText = "Good Afternoon!".localized()
            case 18..<22:
                welcomeText = "Good Evening!".localized()
            default:
                welcomeText = "Good Night!".localized()
            }
            
        welcomeLael.text = welcomeText
    }
    func setupUI() {

        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Set up main view constraints
        mainView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            mainView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        let heightConstraint = mainView.heightAnchor.constraint(equalToConstant: 1244 )
        heightConstraint.priority = UILayoutPriority(250)
        heightConstraint.isActive = true
        
        // Create UIImageView account for left
        accountImages.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(accountImages)
        // Set up constraints for UIImageView
        NSLayoutConstraint.activate([
            accountImages.widthAnchor.constraint(equalToConstant: 50),
            accountImages.heightAnchor.constraint(equalToConstant: 50),
            accountImages.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10),
            accountImages.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 30)
        ])
        // Make the images circular
        accountImages.layer.cornerRadius = 25 // Half of the width/height
        accountImages.clipsToBounds = true
        accountImages.isUserInteractionEnabled = true
        let tappedGuesture = UITapGestureRecognizer(target: self, action: #selector(AccountTapped))
        accountImages.addGestureRecognizer(tappedGuesture)
        
        // Create imageView for notification right
        notificationImage.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(notificationImage)
        // Set up constraints for UIImageView
        NSLayoutConstraint.activate([
            notificationImage.widthAnchor.constraint(equalToConstant: 50),
            notificationImage.heightAnchor.constraint(equalToConstant: 50),
            notificationImage.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10),
            notificationImage.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -30)
        ])
        // Make the image circular
        notificationImage.layer.cornerRadius = 25 // Half of the width/height
        notificationImage.clipsToBounds = true
        
        // Set label account name
        accountNameLabel.translatesAutoresizingMaskIntoConstraints = false
        accountNameLabel.font = UIFont.systemFont(ofSize: 13)
        mainView.addSubview(accountNameLabel)
        accountNameLabel.text = "Kha Sin"
        accountNameLabel.textColor = UIColor(hex: "64646E")
        
        // Set label welcome
//        welcomeLael.text = "Good Morning!".localized()
        welcomeLael.font = UIFont.systemFont(ofSize: 20)
        welcomeLael.textColor = .black
        welcomeLael.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(welcomeLael)
        
        let stackViewTop = UIStackView(arrangedSubviews: [accountNameLabel, welcomeLael])
        stackViewTop.axis = .vertical
        stackViewTop.distribution = .fillProportionally
        stackViewTop.spacing = 5
        stackViewTop.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(stackViewTop)
        
        // Set constraints for stack view
        NSLayoutConstraint.activate([
            stackViewTop.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10),
            stackViewTop.leadingAnchor.constraint(equalTo: accountImages.trailingAnchor, constant: 10),
            stackViewTop.trailingAnchor.constraint(equalTo: notificationImage.leadingAnchor, constant: -10)
        ])
        
        // Set up searchTextField
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(searchTextField)
        searchTextField.font = UIFont.systemFont(ofSize: 13)
        searchTextField.backgroundColor = .white
        searchTextField.layer.cornerRadius = 25
        searchTextField.placeholder = "Discover a place".localized()
        setupTextField(textField: searchTextField, withLeftIcon: UIImage(named: "search"), withRightIcon: UIImage(named: "Filter"))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSearchFieldTap))
        searchTextField.addGestureRecognizer(tapGesture)
        searchTextField.isUserInteractionEnabled = true
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: stackViewTop.bottomAnchor, constant: 20),
            searchTextField.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            searchTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Setup button filler
        setupButton(popularButton, title: "Popular")
        setupButton(mostViewButton, title: "Most View")
        setupButton(recomendedButton, title: "Recomended")
//        popularButton.addTarget(self, action: #selector(popularTapped), for: .touchUpInside)
        
        stackViewFilter = UIStackView(arrangedSubviews: [popularButton, mostViewButton, recomendedButton])
        stackViewFilter.axis = .horizontal
        stackViewFilter.distribution = .fillProportionally
        stackViewFilter.spacing = 10
        stackViewFilter.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(stackViewFilter)
        // Set constraints for stack view
        NSLayoutConstraint.activate([
            stackViewFilter.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 15),
            stackViewFilter.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            stackViewFilter.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20)
        ])

        // MARK: Filter  button
        mainView.addSubview(categoriesButton)
        categoriesButton.isHidden = true
        categoriesButton.backgroundColor = .red

        
        // MARK: View Container Popular Places
        mainView.addSubview(viewContainerPopulars)
        viewContainerPopulars.translatesAutoresizingMaskIntoConstraints = false
        viewContainerPopulars.backgroundColor = .white
        NSLayoutConstraint.activate([
            viewContainerPopulars.topAnchor.constraint(equalTo: stackViewFilter.bottomAnchor, constant: 15),
            viewContainerPopulars.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            viewContainerPopulars.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            viewContainerPopulars.heightAnchor.constraint(equalToConstant: 300)
        ])
        // MARK: Title and more button
        let firstTitleLabel = UILabel()
        firstTitleLabel.text = "Popular Places".localized()
        setupTitle(firstTitleLabel)
        viewContainerPopulars.addSubview(firstTitleLabel)
        
        // first moreButton
        setupMoreButton(firstMoreButton)
        viewContainerPopulars.addSubview(firstMoreButton)
        firstMoreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        let titleStackView = UIStackView(arrangedSubviews: [firstTitleLabel, firstMoreButton])
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fill
        titleStackView.spacing = 0
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        viewContainerPopulars.addSubview(titleStackView)
        // Set constraints for stack view
        //MARK:  Set constraints for popular places
        viewContainerPopulars.addSubview(popularCollectionView)
        
        NSLayoutConstraint.activate([
            // Stack View
            titleStackView.topAnchor.constraint(equalTo: viewContainerPopulars.topAnchor, constant: 10),
            titleStackView.leadingAnchor.constraint(equalTo: viewContainerPopulars.leadingAnchor, constant: 10),
            titleStackView.trailingAnchor.constraint(equalTo: viewContainerPopulars.trailingAnchor, constant: -10),
            
            // collection View
            popularCollectionView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 10),
            popularCollectionView.leadingAnchor.constraint(equalTo: viewContainerPopulars.leadingAnchor),
            popularCollectionView.trailingAnchor.constraint(equalTo: viewContainerPopulars.trailingAnchor),
            popularCollectionView.bottomAnchor.constraint(equalTo: viewContainerPopulars.bottomAnchor)
        ])

        
        
        // MARK: Contianer View of Provinces
        viewContainerProvinces.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(viewContainerProvinces)
        viewContainerProvinces.backgroundColor = .white
        
        // show provinces
        let provinces = UILabel()
        provinces.text = "Provinces".localized()
        setupTitle(provinces)
        viewContainerProvinces.addSubview(provinces)
        
        // second more button
        //        secondMoreButton.setTitle("More", for: .normal)
        setupMoreButton(secondMoreButton)
        viewContainerProvinces.addSubview(secondMoreButton)
        secondMoreButton.addTarget(self, action: #selector(provincesMoreTapped), for: .touchUpInside)
        
        let provincesStackView = UIStackView(arrangedSubviews: [provinces, secondMoreButton])
        provincesStackView.axis = .horizontal
        provincesStackView.distribution = .fill
        provincesStackView.spacing = 0
        provincesStackView.translatesAutoresizingMaskIntoConstraints = false
        viewContainerProvinces.addSubview(provincesStackView)
        
        
        // Set constraints for ContaintView
        NSLayoutConstraint.activate([
            viewContainerProvinces.topAnchor.constraint(equalTo: viewContainerPopulars.bottomAnchor, constant: 5),
            viewContainerProvinces.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            viewContainerProvinces.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            viewContainerProvinces.heightAnchor.constraint(equalToConstant: 450)
        ])
        
        // MARK: Provinces collection View
        viewContainerProvinces.addSubview(provincesCollectionView)
        NSLayoutConstraint.activate([
            provincesStackView.topAnchor.constraint(equalTo: viewContainerProvinces.topAnchor, constant: 10),
            provincesStackView.leadingAnchor.constraint(equalTo: viewContainerProvinces.leadingAnchor, constant: 20),
            provincesStackView.trailingAnchor.constraint(equalTo: viewContainerProvinces.trailingAnchor, constant: -20),
            
            provincesCollectionView.topAnchor.constraint(equalTo: provincesStackView.bottomAnchor),
            provincesCollectionView.leadingAnchor.constraint(equalTo: viewContainerProvinces.leadingAnchor),
            provincesCollectionView.trailingAnchor.constraint(equalTo: viewContainerProvinces.trailingAnchor),
            provincesCollectionView.heightAnchor.constraint(equalToConstant: screenWidth)
        
        ])
        
        //MARK:  setup Cateogries label
        //  MARK: Category collectionView
        categorieLayout.minimumLineSpacing = 10
        categorieLayout.minimumInteritemSpacing = 15
//        categorieLayout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        categorieLayout.scrollDirection = .horizontal
        CategoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: categorieLayout)
        CategoriesCollectionView.contentInset = UIEdgeInsets(top: 50.0, left: 55.0, bottom: 50.0, right: 50.0)
        CategoriesCollectionView.register(ProvincesCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "Cell3")
        setupCollectionView(CategoriesCollectionView)
        
        viewContainerCategory.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(viewContainerCategory)
        viewContainerCategory.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            viewContainerCategory.topAnchor.constraint(equalTo: viewContainerProvinces.bottomAnchor, constant: 5),
            viewContainerCategory.leftAnchor.constraint(equalTo: mainView.leftAnchor),
            viewContainerCategory.rightAnchor.constraint(equalTo: mainView.rightAnchor),
            viewContainerCategory.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
        
        
        // title of Categories
        let titleCategory = UILabel()
        titleCategory.text = "Categories".localized()
        setupTitle(titleCategory)
        viewContainerCategory.addSubview(titleCategory)
        viewContainerCategory.addSubview(CategoriesCollectionView)
        
        NSLayoutConstraint.activate([
            // category constraint label
            titleCategory.topAnchor.constraint(equalTo: viewContainerCategory.topAnchor, constant: 10),
            titleCategory.leadingAnchor.constraint(equalTo: viewContainerCategory.leadingAnchor, constant: 20),
            // collectionView Constraint
            CategoriesCollectionView.topAnchor.constraint(equalTo: titleCategory.bottomAnchor, constant: 5),
            CategoriesCollectionView.bottomAnchor.constraint(equalTo: viewContainerCategory.bottomAnchor),
            CategoriesCollectionView.leadingAnchor.constraint(equalTo: viewContainerCategory.leadingAnchor),
            CategoriesCollectionView.trailingAnchor.constraint(equalTo: viewContainerCategory.trailingAnchor)
            
        ])
        
    }
//    @objc func popularTapped(){
//        categoriesButton.isHidden = false
//        categoriesButton.snp.makeConstraints { make in
//            make.top.equalTo(stackViewFilter.snp.bottom)
//            make.left.right.equalTo(mainView)
//            make.bottom.equalTo(mainView)
//        }
//    }
    @objc func provincesMoreTapped(){
        let viewController = ProvincesMoreViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    @objc func AccountTapped(){
        let viewController = UserProfileViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setupCollectionView(_ collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
    }
    // use for set up  button
    func setupMoreButton (_ button: UIButton){
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("More".localized(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    @objc func moreButtonTapped(){
        let viewController = MoreViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func setupTitle (_ titleLabel: UILabel){
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    // Setup button appearance and actions
    func setupButton(_ button: UIButton, title: String) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func handleSearchFieldTap() {
        print("Search text field tapped")

        // Animate the scale of the searchTextField
        UIView.animate(withDuration: 0.3, animations: {
            self.searchTextField.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { _ in
            // Animate back to original scale
            UIView.animate(withDuration: 0.3, animations: {
                self.searchTextField.transform = CGAffineTransform.identity
            }) { _ in
                // Present the SearchViewController after the animation completes
                let searchVC = SearchViewController()
                self.navigationController?.pushViewController(searchVC, animated: true)
            }
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        // Reset all buttons to default state
        resetButtonColors()
        // Set the clicked button to the selected state
        sender.backgroundColor = .black
        sender.setTitleColor(.white, for: .normal)
    }
    
    func resetButtonColors() {
        let buttons = [popularButton, mostViewButton, recomendedButton]
        for button in buttons {
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
        }
    }
    
    // Set icons in text field
    func setupTextField(textField: UITextField, withLeftIcon leftIcon: UIImage?, withRightIcon rightIcon: UIImage?) {
        if let leftIcon = leftIcon {
            let leftIconView = UIImageView(frame: CGRect(x: 6, y: 0, width: 24, height: 24))
            leftIconView.image = leftIcon
            leftIconView.contentMode = .scaleAspectFit
            
            let leftIconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
            leftIconContainerView.addSubview(leftIconView)
            
            textField.leftView = leftIconContainerView
            textField.leftViewMode = .always
        }
        
        if let rightIcon = rightIcon {
            let rightIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
            rightIconView.image = rightIcon
            rightIconView.contentMode = .scaleAspectFit
            
            let rightIconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
            rightIconContainerView.addSubview(rightIconView)
            
            // Add tap gesture recognizer to the right icon container view
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(rightIconTapped))
            rightIconContainerView.isUserInteractionEnabled = true
            rightIconContainerView.addGestureRecognizer(tapGestureRecognizer)
            
            textField.rightView = rightIconContainerView
            textField.rightViewMode = .always
        }
        
        textField.textAlignment = .left
        
        let placeholderText = textField.placeholder ?? ""
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                .foregroundColor: UIColor.lightGray,
                .paragraphStyle: NSMutableParagraphStyle().apply({
                    $0.alignment = .left
                })
            ]
        )
    }
    
    @objc func rightIconTapped() {
        // Implement the action you want to perform when the right icon is tapped
        print("Right icon tapped! Perform search filter action here.")
        // Add your search filter logic here
    }
    
    
}

// MARK: - UICollectionViewDataSource
extension HomeViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == popularCollectionView {
            return places.count
        }else if collectionView == provincesCollectionView {
            return provinces.count
        }else{
            return categories.count
        }
    }
    private func handleBookmarkButtonTapped(for trip: Pupular, at indexPath: IndexPath) {
        if BookmarkManager.shared.isBookmarked(id: "\(trip.placeId)") {
            BookmarkManager.shared.removeBookmark(byId: "\(trip.placeId)")
        } else {
            BookmarkManager.shared.saveBookmark(trip)
        }
        
        // Reload the specific cell to update its bookmark button
        popularCollectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == popularCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell1", for: indexPath) as! FirstCollectionViewCell
            let place = places[indexPath.item]
            cell.configure(with: place)
            
            cell.bookmarkButtonAction = {[weak self] in
                self?.handleBookmarkButtonTapped(for: place, at: indexPath)
            }
            
            return cell
        }else if collectionView == provincesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! ProvincesCollectionViewCell
            let province = provinces[indexPath.item]
            cell.backgroundColor = .white
            cell.configure(with: province)
            
            return cell
        }else {
            let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell3", for: indexPath) as! ProvincesCategoryCollectionViewCell
            let category = categories[indexPath.item]
            cell3.configure(with: category)
            return cell3
        }
    }
    
    
}


// MARK: UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == provincesCollectionView {
            if indexPath.item == provincesLayout.currentPage {
                print("did select item cell")
                let selectedId = provinces[indexPath.item]
                let provincesDetailView = ProvinceDetailViewController()
                provincesDetailView.provincId = selectedId.provinceId
                navigationController?.pushViewController(provincesDetailView, animated: true)
            } else {
                provincesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                provincesLayout.currentPage = indexPath.item
                provincesLayout.previousOffset = provincesLayout.updateOffSet(provincesCollectionView)
                setupCell()
                print("did scroll item cell")
            }
        } else if collectionView == popularCollectionView {
            print("it work")
            let selected = places[indexPath.item]
            let detailViewController = PopularDetailViewController(selectedPlace: selected)
            detailViewController.selectedPlace = selected
            
            
            navigationController?.pushViewController(detailViewController, animated: true)
            
        }else {
            let categoryVC = DisplayCategoryViewController()
            categoryVC.modalPresentationStyle = .fullScreen
            present(categoryVC, animated: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            setupCell()
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("did end scrolling animation")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setupCell()
    }
    
    private func setupCell() {
        let indexPath = IndexPath(item: provincesLayout.currentPage, section: 0)
        if let cell = provincesCollectionView.cellForItem(at: indexPath) {
            transformCell(cell)
        }
    }
    
    private func transformCell(_ cell: UICollectionViewCell, isEffect: Bool = true) {
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        
        for otherCell in provincesCollectionView.visibleCells {
            if let indexPath = provincesCollectionView.indexPath(for: otherCell), indexPath.item != provincesLayout.currentPage {
                UIView.animate(withDuration: 0.2) {
                    otherCell.transform = .identity
                }
            }
        }
    }
}


// MARK: UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == popularCollectionView{
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
            
        }else if collectionView == provincesCollectionView{
            return CGSize(width: itemWidth, height: itemHeight)
        }else {
            return CGSize(width: 100, height: 130)
        }
    }
}
extension NSMutableParagraphStyle {
    func apply(_ changes: (NSMutableParagraphStyle) -> Void) -> NSMutableParagraphStyle {
        changes(self)
        return self
    }
}

