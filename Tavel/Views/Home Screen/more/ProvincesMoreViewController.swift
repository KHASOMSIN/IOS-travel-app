import UIKit
import SnapKit
import Localize_Swift

class ProvincesMoreViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let searchTextField = TextFieldWithPadding()
    private let titleLabel = UILabel()
    private var provincesMoreCollectionView: UICollectionView!
    private let moreLayout = UICollectionViewFlowLayout()

    private var provincces:[ProvincesModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        setConstraints()
        setupCustomBackButton()
        localizeUI() // Localize the UI elements
        fetchProvincesData()
    }
    func fetchProvincesData() {
        APIClient.shared.fetchProvinces { [weak self] (fetchedProvinces) in
        guard let self = self, let provinces = fetchedProvinces else { return }
            self.provincces = provinces
            DispatchQueue.main.async {
                self.provincesMoreCollectionView.reloadData()
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
        
        fetchProvincesData()
        provincesMoreCollectionView.reloadData()
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
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        searchTextField.font = UIFont.systemFont(ofSize: 13)
        searchTextField.backgroundColor = .white
        searchTextField.layer.cornerRadius = 25
        searchTextField.placeholder = "Discover a place".localized()
        setupTextField(textField: searchTextField, withLeftIcon: UIImage(named: "search"), withRightIcon: UIImage(named: "Filter"))
        
        moreLayout.scrollDirection = .vertical
        moreLayout.minimumLineSpacing = 10
        moreLayout.minimumInteritemSpacing = 10
        
        provincesMoreCollectionView = UICollectionView(frame: .zero, collectionViewLayout: moreLayout)
        provincesMoreCollectionView.register(ProvincesCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        provincesMoreCollectionView.dataSource = self
        provincesMoreCollectionView.delegate = self
        provincesMoreCollectionView.backgroundColor = .white
        provincesMoreCollectionView.showsHorizontalScrollIndicator = false
        provincesMoreCollectionView.showsVerticalScrollIndicator = false
        contentView.addSubview(provincesMoreCollectionView)
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide.snp.width)
            make.height.equalTo(scrollView.frameLayoutGuide.snp.height).priority(.low)
        }

        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.left.equalTo(contentView).inset(20)
            make.right.equalTo(contentView).inset(20)
            make.height.equalTo(50)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(20)
            make.left.equalTo(contentView.snp.left).offset(20)
        }

        provincesMoreCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(contentView.snp.left).offset(20)
            make.right.equalTo(contentView.snp.right).offset(-20)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
            make.height.greaterThanOrEqualTo(450)
        }
    }

    private func localizeUI() {
        searchTextField.placeholder = "Discover Provinces".localized()
        titleLabel.text = "Provinces".localized()
        self.title = "Provinces".localized()
    }
}

extension ProvincesMoreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return provincces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProvincesCollectionViewCell
        let province = provincces[indexPath.row]
        cell.configure(with: province)
        cell.backgroundColor = .red
        return cell
    }
}

extension ProvincesMoreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 2
        let spacingBetweenCells: CGFloat = moreLayout.minimumInteritemSpacing
        let totalSpacing = (numberOfColumns - 1) * spacingBetweenCells
        let width = (collectionView.frame.width - totalSpacing) / numberOfColumns
        return CGSize(width: width, height: 270)
    }
}



extension ProvincesMoreViewController {
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

