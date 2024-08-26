import UIKit
import SnapKit
import Alamofire

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {

    let mainView = UIView()
    let searchTextField = UITextField()
    let popularButton = UIButton()
    let mostViewButton = UIButton()
    let recomendedButton = UIButton()
    var stackViewFilter: UIStackView!
    
    var searchCollectionView: UICollectionView!
    let searchLayout = UICollectionViewFlowLayout()
    
    var searchResults: [Pupular] = []

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "F3F2EC")
        setupCustomBackButton()
        
        let tappGuesture = UITapGestureRecognizer(target: self, action: #selector(dismisKeyoard))
        view.addGestureRecognizer(tappGuesture)
    
        
        // Add mainView to the controller's view
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide) // Pin mainView to all edges of the controller's view
        }
        
        // Add and setup the searchTextField
        mainView.addSubview(searchTextField)
        searchTextField.font = UIFont.systemFont(ofSize: 13)
        searchTextField.backgroundColor = .white
        searchTextField.layer.cornerRadius = 25
        searchTextField.placeholder = "Discover a place".localized()
        setupTextField(textField: searchTextField, withLeftIcon: UIImage(named: "search"), withRightIcon: UIImage(named: "Filter"))
        
        // Setup SnapKit constraints for searchTextField
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(mainView.safeAreaLayoutGuide).offset(20) // Adjust offset as needed
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        // Setup buttons
        setupButton(popularButton, title: "Popular")
        setupButton(mostViewButton, title: "Most View")
        setupButton(recomendedButton, title: "Recomended")
        
        // Add target actions for the buttons
        popularButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        mostViewButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        recomendedButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        // Initialize stackViewFilter with the buttons
        stackViewFilter = UIStackView(arrangedSubviews: [popularButton, mostViewButton, recomendedButton])
        stackViewFilter.axis = .horizontal
        stackViewFilter.distribution = .fillProportionally
        stackViewFilter.spacing = 10
        mainView.addSubview(stackViewFilter)
        
        // Setup SnapKit constraints for stackViewFilter
        stackViewFilter.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        // Set up the collectionView
        setupCollectionView()
        searchTextField.delegate = self
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
            searchCollectionView.reloadData()
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

    
    func setupCollectionView() {
        // Initialize the collection view with the layout
        searchLayout.scrollDirection = .vertical
        searchLayout.minimumLineSpacing = 10
        searchLayout.minimumInteritemSpacing = 10
        
        searchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: searchLayout)
        searchCollectionView.backgroundColor = .clear
        
        // Register a cell class for the collection view
        searchCollectionView.register(FirstCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        
        mainView.addSubview(searchCollectionView)

        // Set up SnapKit constraints for searchCollectionView
        searchCollectionView.snp.makeConstraints { make in
            make.top.equalTo(stackViewFilter.snp.bottom).offset(5)
            make.leading.trailing.equalTo(view).inset(0)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    @objc func dismisKeyoard(){
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
        
        // Remove 'Back' text and Title from Navigation Bar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = "Search"
    }
    
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTextField.becomeFirstResponder() // Show keyboard automatically
    }

    func setupButton(_ button: UIButton, title: String) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        // Reset all buttons to their normal state
        [popularButton, mostViewButton, recomendedButton].forEach { button in
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
        }
        
        // Highlight the selected button
        sender.backgroundColor = .black
        sender.setTitleColor(.white, for: .normal)
    }
    
    func handleSearchResults(_ results: [Pupular]) {
        self.searchResults = results
        self.searchCollectionView.reloadData()
    }
    
}
extension SearchViewController {
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FirstCollectionViewCell
        let place = searchResults[indexPath.item]
        // Configure cell with place data
        cell.configure(with: place)
        return cell
    }

}
extension SearchViewController: UICollectionViewDelegateFlowLayout {
//    / Implement the delegate method to size the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10) // Adjust as needed
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust as needed
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust as needed
    }
}

extension SearchViewController {
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
