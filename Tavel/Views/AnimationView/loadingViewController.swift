import UIKit
import NVActivityIndicatorView

class LoadingViewController: UIViewController {
    let loadingView = LoadingView(message: "Loading...")

    init() {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.addSubview(loadingView)
        loadingView.layer.cornerRadius = 10
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 150),
            loadingView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // Method to show the loading view
//    func showLoading() {
//        if !children.contains(where: { $0 is LoadingViewController }) {
//            let loadingVC = LoadingViewController()
//            loadingVC.modalPresentationStyle = .overCurrentContext
//            present(loadingVC, animated: true, completion: nil)
//        }
//    }
    
    // Method to hide the loading view
//    func hideLoading() {
//        if let loadingVC = children.first(where: { $0 is LoadingViewController }) {
//            loadingVC.dismiss(animated: true, completion: nil)
//        }
//    }
}

class LoadingView: UIView {
    private let activityIndicator = NVActivityIndicatorView(frame: .zero)
    private let messageLabel = UILabel()
    
    private var message: String?
    
    init(message: String) {
        self.message = message
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateText(_ message: String) {
        self.message = message
        messageLabel.text = message
        layoutIfNeeded()
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 10
        addSubview(activityIndicator)
        addSubview(messageLabel)
        
        activityIndicator.type = .ballTrianglePath
        activityIndicator.color = .black
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            
            messageLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        layoutIfNeeded()
        activityIndicator.startAnimating()
    }
}
