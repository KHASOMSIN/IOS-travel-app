import UIKit
import SnapKit
import Localize_Swift

class ChangePasswordViewController: UIViewController {

    // Declare scrollView
    private let scrollView = UIScrollView()
    
    // Declare contentView for the scrollView
    private let contentView = UIView()

    // UI elements
    private let logoBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 50
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 10
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Change Password".localized()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let oldPasswordTextField: UITextField = {
        let textField = TextFieldWithPadding()
        textField.borderColor = .black.withAlphaComponent(0.3)
        textField.placeholder = "Old Password".localized()
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let newPasswordTextField: UITextField = {
        let textField = TextFieldWithPadding()
        textField.borderColor = .black.withAlphaComponent(0.3)
        textField.placeholder = "New Password".localized()
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let confirmPasswordTextField: UITextField = {
        let textField = TextFieldWithPadding()
        textField.borderColor = .black.withAlphaComponent(0.3)
        textField.placeholder = "Confirm Password".localized()
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let changePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Password".localized(), for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(changePasswordButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // Constraint for the change password button's bottom
    private var changePasswordButtonBottomConstraint: Constraint?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "C4C4C4")
        setupScrollView()
        setupUIElements()
        setupKeyboardNotifications()
        setupCustomBackButton()
        
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGuesture)
        
        // Add observer for language change notification
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
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
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
        }
    }
    
    private func setupUIElements() {
        contentView.addSubview(logoBackgroundView)
        contentView.addSubview(logoImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(oldPasswordTextField)
        contentView.addSubview(newPasswordTextField)
        contentView.addSubview(confirmPasswordTextField)
        contentView.addSubview(changePasswordButton)
        
        logoBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.center.equalTo(logoBackgroundView)
            make.width.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoBackgroundView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        oldPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        newPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(oldPasswordTextField.snp.bottom).offset(20)
            make.left.equalTo(oldPasswordTextField)
            make.right.equalTo(oldPasswordTextField)
            make.height.equalTo(50)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(newPasswordTextField.snp.bottom).offset(20)
            make.left.equalTo(newPasswordTextField)
            make.right.equalTo(newPasswordTextField)
            make.height.equalTo(50)
        }
        
        changePasswordButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(50)
            make.left.equalTo(confirmPasswordTextField)
            make.right.equalTo(confirmPasswordTextField)
            make.height.equalTo(50)
            changePasswordButtonBottomConstraint = make.bottom.equalToSuperview().offset(-20).constraint
        }
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        logoBackgroundView.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(10)
        }
        changePasswordButton.snp.updateConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(30)
        }
            
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        logoBackgroundView.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(50)
        }
        changePasswordButton.snp.updateConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(50)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func changePasswordButtonTapped() {
        print("Change Password button tapped")
    }
    
    @objc private func languageChanged() {
        updateLocalizedStrings()
    }
    
    private func updateLocalizedStrings() {
        titleLabel.text = "Change Password".localized()
        oldPasswordTextField.placeholder = "Old Password".localized()
        newPasswordTextField.placeholder = "New Password".localized()
        confirmPasswordTextField.placeholder = "Confirm Password".localized()
        changePasswordButton.setTitle("Change Password".localized(), for: .normal)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
