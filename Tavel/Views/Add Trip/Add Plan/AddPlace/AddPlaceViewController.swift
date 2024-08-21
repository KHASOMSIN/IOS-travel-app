import UIKit
import SnapKit

protocol AddPlaceDelegate: AnyObject {
    func didSelectPlace(_ place: String)
}

class AddPlaceViewController: UIViewController {

    weak var delegate: AddPlaceDelegate?
    

    private let tableView = UITableView()
    private let findPlace = TextFieldWithPadding()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        setupUI()
        setupTableView()
        setupViewBackground()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViewBackground()
    }

    func setupUI() {
        let locationLabel = UILabel()
        view.addSubview(locationLabel)
        locationLabel.text = "Where to?"
        locationLabel.font = UIFont.boldSystemFont(ofSize: 20)
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(20)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
        }

        findPlace.borderColor = .gray
        findPlace.layer.borderWidth = 0.6
        findPlace.placeholder = "Where you want to go"
        findPlace.setupLeftIcon(UIImage(named: "Location"))

        view.addSubview(findPlace)
        findPlace.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(15)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
            make.height.equalTo(50)
        }

        // Add the table view below the text field
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(findPlace.snp.bottom).offset(15)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
            make.bottom.equalTo(view.snp.bottom).offset(-20)
        }
    }

    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }

    func setupViewBackground() {
        let path = UIBezierPath(roundedRect: view.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 16, height: 16))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }
}

extension AddPlaceViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 // Example count; replace with your actual data
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Place \(indexPath.row + 1)" // Example content; replace with your actual data
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlace = "Place \(indexPath.row + 1)" // Example content; replace with your actual data
        delegate?.didSelectPlace(selectedPlace)
        dismiss(animated: true, completion: nil)
    }
}
