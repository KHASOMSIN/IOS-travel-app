import UIKit
import SnapKit

class SaveViewController: UIViewController {

    let savedScrollView = UIScrollView()
    let contenView = UIView()
    var bookmarkedTrips: [Pupular] = []

    // Collection View
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(FirstCollectionViewCell.self, forCellWithReuseIdentifier: "Cell1")
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "F3F2EC")
        setupNavigationTitle()
        setupView()
        setupConstraint()
        loadBookmarkedTrips()

        collectionView.dataSource = self
        collectionView.delegate = self
        updateCollectionViewLayout(for: UIDevice.current.orientation)

        // Add observer for device orientation changes
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBookmarkedTrips()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadBookmarkedTrips()
    }

    private func loadBookmarkedTrips() {
        bookmarkedTrips = BookmarkManager.shared.getBookmarks()
        collectionView.reloadData()
    }

    func setupNavigationTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "Your Saved Trips"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        
        // Align the title to the left
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        titleLabel.frame = titleView.bounds
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleView.snp.leading).offset(10)
            make.centerY.equalTo(titleView.snp.centerY)
        }
        
        self.navigationItem.titleView = titleView
    }

    func setupView() {
        view.addSubview(savedScrollView)
        savedScrollView.addSubview(contenView)
        contenView.addSubview(collectionView)
        savedScrollView.showsVerticalScrollIndicator = false
        savedScrollView.showsHorizontalScrollIndicator = false
    }

    func setupConstraint() {
        savedScrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contenView.snp.makeConstraints { make in
            make.edges.equalTo(savedScrollView)
            make.width.equalTo(savedScrollView.snp.width)
            make.height.greaterThanOrEqualTo(view.snp.height)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(contenView.snp.top).offset(0)
            make.leading.trailing.equalTo(contenView).inset(10)
            make.bottom.equalTo(contenView.snp.bottom).offset(-20)
            make.height.equalTo(collectionView.contentSize.height).priority(250)
        }
    }

    // Method to update collection view layout based on orientation
    private func updateCollectionViewLayout(for orientation: UIDeviceOrientation) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        if orientation.isLandscape {
            layout.scrollDirection = .horizontal
        } else {
            layout.scrollDirection = .vertical
        }

        collectionView.reloadData()
    }

    // Method to handle orientation changes
    @objc private func didChangeOrientation() {
        updateCollectionViewLayout(for: UIDevice.current.orientation)
    }
}

extension SaveViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarkedTrips.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell1", for: indexPath) as! FirstCollectionViewCell
        let place = bookmarkedTrips[indexPath.item]
        cell.configure(with: place)
        cell.bookmarkButtonAction = { [weak self] in
            guard let self = self else { return }
            self.handleUnbookmarkAction(for: place, at: indexPath)
        }

        return cell
    }

    private func handleUnbookmarkAction(for trip: Pupular, at indexPath: IndexPath) {
        guard indexPath.row < bookmarkedTrips.count else {
            print("Index out of range. Row: \(indexPath.row), Count: \(bookmarkedTrips.count)")
            return
        }

        BookmarkManager.shared.removeBookmark(byId: "\(trip.placeId)")
        bookmarkedTrips.remove(at: indexPath.row)

        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [indexPath])
        }, completion: { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        })
    }
}

extension SaveViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIDevice.current.orientation.isLandscape ? collectionView.frame.width / 2 - 15 : collectionView.frame.width - 20
        return CGSize(width: width, height: 250)
    }
}
