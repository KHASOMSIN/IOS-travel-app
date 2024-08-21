//
//  SignUpViewController.swift
//  Tavel
//
//  Created by user245540 on 7/14/24.
//

import UIKit
import Alamofire

struct RegistrationRequest: Encodable {
    let fullname: String
    let email: String
    let password: String
}

// Model for registration response
// Model for registration response
struct RegistrationResponse: Decodable {
    let message: String
}

class SignUpViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let mainView = UIView()
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    let nameLabel = UILabel()
    let fullnameTextField = TextFieldWithPadding()
    let emailLabel = UILabel()
    let emailTextField = TextFieldWithPadding()
    let passwordLabel = UILabel()
    let passwordTextField = TextFieldWithPadding()
    let confirmPasswordLabel = UILabel()
    let confirmPasswordTextField = TextFieldWithPadding()
    let radioButton = RadioButton()
    let radioLabel = UILabel()
    let loginButton = UIButton()
    let questionLabel = UILabel()
    let loginLabel = UILabel()
    let horizontalStackView = UIStackView()
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        // Scroll view setup
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Main view setup
        mainView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            mainView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mainView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        let heightConstraint = mainView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        heightConstraint.priority = UILayoutPriority(250)
        heightConstraint.isActive = true
        
        // Image setup
        let logoImage = UIImageView(image: UIImage(named: "TravelAppLogo"))
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(logoImage)
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 50),
            logoImage.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            logoImage.heightAnchor.constraint(equalToConstant: 100),
            logoImage.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        // Title label setup
        titleLabel.text = "Let’s get started"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20)
        ])
        
        // Detail label setup
        detailLabel.font = UIFont.systemFont(ofSize: 17)
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = .zero
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.text = "Create your new account and find more beautiful destinations"
        mainView.addSubview(detailLabel)
        NSLayoutConstraint.activate([
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            detailLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 20),
            detailLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -20)
        ])
        
        // Name label setup
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.text = "Name"
        mainView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 20)
        ])
        
        // Full name text field setup
        //        fullnameTextField.borderStyle = .roundedRect
        fullnameTextField.borderColor = UIColor(hex: "#BFBFBF")
        fullnameTextField.backgroundColor = .white
        fullnameTextField.placeholder = "Enter your full name"
        fullnameTextField.font = UIFont.systemFont(ofSize: 15)
        fullnameTextField.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(fullnameTextField)
        NSLayoutConstraint.activate([
            fullnameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            fullnameTextField.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 20),
            fullnameTextField.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -20),
            fullnameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Email label setup
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.font = UIFont.systemFont(ofSize: 15)
        emailLabel.text = "Email"
        mainView.addSubview(emailLabel)
        NSLayoutConstraint.activate([
            emailLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            emailLabel.topAnchor.constraint(equalTo: fullnameTextField.bottomAnchor, constant: 10)
        ])
        
        // Email text field setup
        //        emailTextField.borderStyle = .roundedRect
        emailTextField.borderColor =  UIColor(hex: "#BFBFBF")
        emailTextField.backgroundColor = .white
        emailTextField.placeholder = "Enter your email"
        emailTextField.font = UIFont.systemFont(ofSize: 15)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(emailTextField)
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            emailTextField.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 20),
            emailTextField.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Password label setup
        passwordLabel.font = UIFont.systemFont(ofSize: 15)
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.text = "Password"
        mainView.addSubview(passwordLabel)
        NSLayoutConstraint.activate([
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20)
        ])
        
        // Password text field setup
        //        passwordTextField.borderStyle = .roundedRect
        passwordTextField.borderColor =  UIColor(hex: "#BFBFBF")
        passwordTextField.backgroundColor = .white
        passwordTextField.placeholder = "Enter your password"
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.font = UIFont.systemFont(ofSize: 15)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.enablePasswordToggle()
        mainView.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Confirm password label setup
        confirmPasswordLabel.font = UIFont.systemFont(ofSize: 15)
        confirmPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordLabel.text = "Re-type Password"
        mainView.addSubview(confirmPasswordLabel)
        NSLayoutConstraint.activate([
            confirmPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            confirmPasswordLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20)
        ])
        
        // Confirm password text field setup
        //        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.borderColor =  UIColor(hex: "#BFBFBF")
        confirmPasswordTextField.backgroundColor = .white
        confirmPasswordTextField.placeholder = "Confirm your password"
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.font = UIFont.systemFont(ofSize: 15)
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.enablePasswordToggle()
        mainView.addSubview(confirmPasswordTextField)
        NSLayoutConstraint.activate([
            confirmPasswordTextField.topAnchor.constraint(equalTo: confirmPasswordLabel.bottomAnchor, constant: 10),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Radio button setup
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(radioButton)
        NSLayoutConstraint.activate([
            radioButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 8),
            radioButton.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 20),
            radioButton.widthAnchor.constraint(equalToConstant: 30),
            radioButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Radio label setup
        radioLabel.text = "Accept terms of service"
        radioLabel.textColor = .red
        radioLabel.translatesAutoresizingMaskIntoConstraints = false
        radioLabel.font = UIFont.systemFont(ofSize: 11)
        mainView.addSubview(radioLabel)
        NSLayoutConstraint.activate([
            radioLabel.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 15),
            radioLabel.leftAnchor.constraint(equalTo: radioButton.rightAnchor, constant: 5)
        ])
        
        // Sign up button setup
        loginButton.setTitle("Sign Up", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = UIColor(hex: "080E1E")
        loginButton.layer.cornerRadius = 10
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: radioLabel.bottomAnchor, constant: 50),
            loginButton.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 20),
            loginButton.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        loginButton.addTarget(self, action: #selector(signUpBtnTapped), for: .touchUpInside)
        
        // Horizontal stack view setup
        questionLabel.text = "You have an account?"
        questionLabel.textAlignment = .right
        questionLabel.font = UIFont.systemFont(ofSize: 13)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        loginLabel.text = "Sign In"
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.textColor = .red
        loginLabel.textAlignment = .left
        loginLabel.isUserInteractionEnabled = true
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center
        horizontalStackView.spacing = 5
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.addArrangedSubview(questionLabel)
        horizontalStackView.addArrangedSubview(loginLabel)
        mainView.addSubview(horizontalStackView)
        
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 30),
            horizontalStackView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
        
        let loginTapGesture = UITapGestureRecognizer(target: self, action: #selector(loginTapped))
        loginLabel.addGestureRecognizer(loginTapGesture)
        
    }
    
    @objc func signUpBtnTapped() {
        // Retrieve user input
        guard let fullname = fullnameTextField.text, !fullname.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let passwordConfirmation = confirmPasswordTextField.text, !passwordConfirmation.isEmpty else {
            // Show error if any field is empty
            showAlert(title: "Error", message: "All fields are required")
            return
        }
        
        if password != passwordConfirmation {
            showAlert(title: "Error", message: "Passwords do not match")
            return
        }
        
        if !radioButton.isSelected {
            showAlert(title: "Error", message: "You must accept the terms of service")
            return
        }
        
        // Create the registration request
        let registrationRequest = RegistrationRequest(fullname: fullname, email: email, password: password)
        
        // Call the API to register
        registerUser(with: registrationRequest)
        DataManager.shared.email = email
    }
    
    
    @IBAction func loginTapped() {
        print("Sign In")
        self.dismiss(animated: true)
    }
    
    
    // MARK: functions
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true, completion: nil)
    }
    
    private func registerUser(with request: RegistrationRequest) {
        // Show activity indicator
        activityIndicator.startAnimating()
        
        let url = "https://travel-flame-ten.vercel.app/auth/register" // Replace with your actual endpoint
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: headers).responseDecodable(of: RegistrationResponse.self) { response in
            // Stop activity indicator
            self.activityIndicator.stopAnimating()
            
            switch response.result {
            case .success(let registrationResponse):
                // Since the response only has a message, use it directly
                self.showAlert(title: "Success", message: registrationResponse.message) {
                    // Perform further actions after successful registration, if needed
                    let viewController = OTPverifiedViewController()
                    self.present(viewController, animated: true)
//                    DataManager.shared.email = self.emailTextField.text
                }
            case .failure(let error):
                // Handle request failure
                self.showAlert(title: "Error", message: "Registration failed: \(error.localizedDescription)")
            }
        }
    }
}
