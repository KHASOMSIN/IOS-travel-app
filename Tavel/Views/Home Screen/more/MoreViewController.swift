import UIKit
import SnapKit
import Localize_Swift

class MoreViewController: UIViewController {

    let scrollView = UIScrollView()
    let contentView = UIView()
    let searchTextField = TextFieldWithPadding()
    let titleLabel = UILabel()
    var allPlaceCollectionView: UICollectionView
    let allPlaceLayoutView = UICollectionViewFlowLayout()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        allPlaceCollectionView = UICollectionView(frame: .zero, collectionViewLayout: allPlaceLayoutView)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupCustomBackButton()
        view.backgroundColor = .white

        allPlaceCollectionView.dataSource = self
        allPlaceCollectionView.delegate = self

        // Observe device orientation change
        NotificationCenter.default.addObserver(self, selector: #selector(handleRotation), name: UIDevice.orientationDidChangeNotification, object: nil)

        // Observe language change
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
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

        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)

        allPlaceLayoutView.scrollDirection = .vertical
        allPlaceLayoutView.minimumLineSpacing = 10

        allPlaceCollectionView.showsVerticalScrollIndicator = false
        allPlaceCollectionView.showsHorizontalScrollIndicator = false
        allPlaceCollectionView.alwaysBounceVertical = true
        allPlaceCollectionView.register(FirstCollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        // Set localized strings
        updateLocalizedText()
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
            make.right.equalTo(contentView.snp.right).offset(20)
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
    }
}

extension MoreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularPlace.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FirstCollectionViewCell
        let place = popularPlace[indexPath.item]
        cell.configure(with: place)
        
        cell.bookmarkButtonAction = { [weak self] in
            self?.handleBookmarkButtonTapped(for: place, at: indexPath)
        }
        return cell
    }

    private func handleBookmarkButtonTapped(for trip: PopularPlace, at indexPath: IndexPath) {
        if BookmarkManager.shared.isBookmarked(id: trip.id) {
            BookmarkManager.shared.removeBookmark(byId: trip.id)
        } else {
            BookmarkManager.shared.saveBookmark(trip)
        }
        
        // Reload the specific cell to update its bookmark button
        allPlaceCollectionView.reloadItems(at: [indexPath])
    }
}

extension MoreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Adjust the cell size based on the layout or content
        if UIDevice.current.orientation.isLandscape {
            return CGSize(width: collectionView.frame.width * 0.6, height: collectionView.frame.height - 40)
        } else {
            return CGSize(width: collectionView.frame.width, height: 270)
        }
    }
}
