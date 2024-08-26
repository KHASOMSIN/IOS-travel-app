import UIKit
import SnapKit
import Localize_Swift
import Alamofire

class MoreViewController: UIViewController, UITextFieldDelegate {

    let scrollView = UIScrollView()
    let contentView = UIView()
    let searchTextField = TextFieldWithPadding()
    let titleLabel = UILabel()
    var noResultsLabel = UILabel()
    var allPlaceCollectionView: UICollectionView
    let allPlaceLayoutView = UICollectionViewFlowLayout()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        allPlaceCollectionView = UICollectionView(frame: .zero, collectionViewLayout: allPlaceLayoutView)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var popular: [Pupular] = []
    var searchResults: [Pupular] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupCustomBackButton()
        fetchPlaces()
        view.backgroundColor = .white

        allPlaceCollectionView.dataSource = self
        allPlaceCollectionView.delegate = self
        searchTextField.delegate = self

        // Observe device orientation change
        NotificationCenter.default.addObserver(self, selector: #selector(handleRotation), name: UIDevice.orientationDidChangeNotification, object: nil)

        // Observe language change
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        fetchSearchResults(query: updatedText)
        return true
    }

    func fetchSearchResults(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            allPlaceCollectionView.isHidden = false
            noResultsLabel.isHidden = true
            allPlaceCollectionView.reloadData()
            return
        }
        
        let urlString = "\(urlTravel)travel/search?q=\(query)"
        AF.request(urlString).responseDecodable(of: SearchResponse.self) { [weak self] response in
            switch response.result {
            case .success(let searchResponse):
                DispatchQueue.main.async {
                    self?.handleSearchResults(searchResponse.data)
                }
            case .failure(let error):
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }

    func handleSearchResults(_ results: [Pupular]) {
        self.searchResults = results
        let hasResults = !results.isEmpty
        noResultsLabel.isHidden = hasResults
        allPlaceCollectionView.isHidden = !hasResults
        self.allPlaceCollectionView.reloadData()
    }
    
    private func fetchPlaces() {
        APIPupular.shared.fetchPlaces { result in
            switch result {
            case .success(let places):
                self.popular = places
                DispatchQueue.main.async {
                    self.allPlaceCollectionView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch places: \(error)")
            }
        }
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

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    func setupCustomBackButton() {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "custom_back_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = .black  // Set the desired color here
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }

    private func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(searchTextField)
        contentView.addSubview(titleLabel)
        contentView.addSubview(allPlaceCollectionView)
        view.addSubview(noResultsLabel)

        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)

        allPlaceLayoutView.scrollDirection = .vertical
        allPlaceLayoutView.minimumLineSpacing = 10

        allPlaceCollectionView.showsVerticalScrollIndicator = false
        allPlaceCollectionView.showsHorizontalScrollIndicator = false
        allPlaceCollectionView.alwaysBounceVertical = true
        allPlaceCollectionView.register(FirstCollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        noResultsLabel.text = "No Place Found".localized()
        noResultsLabel.textAlignment = .center
        noResultsLabel.isHidden = true // Initially hidden

        // Set localized strings
        updateLocalizedText()
        
        searchTextField.font = UIFont.systemFont(ofSize: 13)
        searchTextField.backgroundColor = .white
        searchTextField.layer.cornerRadius = 25
        searchTextField.placeholder = "Discover a place".localized()
        setupTextField(textField: searchTextField, withLeftIcon: UIImage(named: "search"), withRightIcon: UIImage(named: "Filter"))
    }

    private func setupConstraints() {
        // scrollView constraints
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide) // Ensure it fills the view
        }

        // contentView constraints
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide) // Fill the scroll view
            make.width.equalTo(scrollView.frameLayoutGuide.snp.width) // Match the width
            make.height.equalTo(scrollView.frameLayoutGuide.snp.height).priority(.low)
        }

        // searchTextField constraints
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10) // Padding from top
            make.left.equalTo(contentView).inset(20)
            make.right.equalTo(contentView.snp.right).offset(-20)
            make.height.equalTo(50)
        }

        // titleLabel constraints
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(10) // Space below search text field
            make.left.equalTo(contentView.snp.left).offset(20) // Align with left
        }

        // allPlaceCollectionView constraints
        allPlaceCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalTo(contentView)
            make.bottom.equalTo(contentView.snp.bottom)
            make.height.greaterThanOrEqualTo(450)
        }

        // Center the noResultsLabel in the view
        noResultsLabel.snp.makeConstraints { make in
            make.center.equalTo(view) // Center in the parent view
            make.width.equalTo(view).multipliedBy(0.8) // Adjust width
            make.height.equalTo(40)
        }
    }

    @objc private func handleRotation() {
        if UIDevice.current.orientation.isLandscape {
            // Change to horizontal scroll in landscape
            allPlaceLayoutView.scrollDirection = .horizontal
            allPlaceCollectionView.snp.updateConstraints { make in
                make.bottom.equalTo(contentView.snp.bottom)
                make.height.greaterThanOrEqualTo(280)
            }
        } else {
            // Change to vertical scroll in portrait
            allPlaceLayoutView.scrollDirection = .vertical
            allPlaceCollectionView.snp.updateConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom)
                make.left.right.equalTo(contentView)
                make.bottom.equalTo(contentView.snp.bottom).offset(-20)
                make.height.greaterThanOrEqualTo(450)
            }
        }
        allPlaceCollectionView.collectionViewLayout.invalidateLayout() // Refresh the layout
    }

    @objc private func languageChanged() {
        updateLocalizedText()
    }

    private func updateLocalizedText() {
        searchTextField.placeholder = "Discover Places".localized()
        titleLabel.text = "All Places".localized()
        noResultsLabel.text = "No Place Found".localized()
    }
}

extension MoreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.isEmpty ? popular.count : searchResults.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? FirstCollectionViewCell else {
            return UICollectionViewCell()
        }

        let place = searchResults.isEmpty ? popular[indexPath.item] : searchResults[indexPath.item]
        cell.configure(with: place)
        
        return cell
    }
}


extension MoreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Adjust the cell size based on the layout or content
        if UIDevice.current.orientation.isLandscape {
            return CGSize(width: collectionView.frame.width * 0.6, height: collectionView.frame.height - 40)
        } else {
            return CGSize(width: collectionView.frame.width, height: 260)
        }
    }
}

extension MoreViewController {
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
    
    @objc func rightIconTapped(){
        
    }
}
