import UIKit
import SnapKit

class UserProfileViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray // Placeholder color
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "profile11")
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "KHA SIN"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "khasomsin@gmail.com"
        return label
    }()
    
    private let dobLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "12/05/2001"
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "Male"
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "0703219291"
        return label
    }()
    
    private let iconSize = CGSize(width: 24, height: 24)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        setupConstraints()
        setupCustomBackButton()
        setupRightButoon()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
        
        // Remove 'Back' text and Title from Navigation Bar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = ""
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupCustomBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "custom_back_icon"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }
    func setupRightButoon() {
        let rightButton = UIButton(type: .system)
        let image = UIImage(named: "uerupdate")?.resize(to: CGSize(width: 24, height: 24))
        rightButton.setImage(image, for: .normal)
        rightButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        
        let rightBtnItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightBtnItem
    }
    
    @objc func editTapped() {
        let viewController = EditUserProfileViewController()
        navigationController?.pushViewController(viewController, animated: true)

    }
    
    private func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(profileImageView)
        
        let nameStackView = createProfileStackView(icon: UIImage(named: "Profile_selected"), label: userNameLabel)
        let emailStackView = createProfileStackView(icon: UIImage(named: "email"), label: emailLabel)
        let dobStackView = createProfileStackView(icon: UIImage(named: "dob"), label: dobLabel)
        let genderStackView = createProfileStackView(icon: UIImage(named: "gender"), label: genderLabel)
        let phoneStackView = createProfileStackView(icon: UIImage(named: "Call"), label: phoneNumberLabel)
        
        contentView.addSubview(nameStackView)
        contentView.addSubview(createSeparatorView())
        contentView.addSubview(emailStackView)
        contentView.addSubview(createSeparatorView())
        contentView.addSubview(dobStackView)
        contentView.addSubview(createSeparatorView())
        contentView.addSubview(genderStackView)
        contentView.addSubview(createSeparatorView())
        contentView.addSubview(phoneStackView)
        contentView.addSubview(createSeparatorView())
    }
    
    private func createProfileStackView(icon: UIImage?, label: UILabel) -> UIStackView {
        let imageView = UIImageView(image: icon)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.size.equalTo(iconSize)
        }
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        
        return stackView
    }
    
    private func createSeparatorView() -> UIView {
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1) // Height of the separator line
        }
        return separatorView
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.height.equalTo(100)
        }
        
        var previousView: UIView = profileImageView
        for subview in contentView.subviews.dropFirst() {
            subview.snp.makeConstraints { make in
                make.left.equalTo(contentView.snp.left).offset(20)
                make.right.equalTo(contentView.snp.right).offset(-20)
                make.top.equalTo(previousView.snp.bottom).offset(18)
            }
            previousView = subview
        }
        
        previousView.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
    }
}
