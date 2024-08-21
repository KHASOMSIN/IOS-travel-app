import UIKit

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct ResponseData: Codable {
    let message: String
    let status: Int
    let data: ResponseDetail
    
    enum CodingKeys: String, CodingKey {
        case message
        case status
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decode(String.self, forKey: .message)
        status = try container.decode(Int.self, forKey: .status)
        
        if status == 200 {
            let jwtData = try container.decode(ResponseDataDetail.self, forKey: .data)
            data = .jwt(jwtData.jwt)
        } else {
            let errorData = try container.decode(ErrorData.self, forKey: .data)
            data = .error(errorData)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(message, forKey: .message)
        try container.encode(status, forKey: .status)
        
        switch data {
        case .jwt(let jwtData):
            try container.encode(jwtData, forKey: .data)
        case .error(let errorData):
            try container.encode(errorData, forKey: .data)
        }
    }
}

struct ResponseDataDetail: Codable {
    let jwt: JWTData
    
    enum CodingKeys: String, CodingKey {
        case jwt = "jwt"
    }
}

enum ResponseDetail {
    case jwt(JWTData)
    case error(ErrorData)
}

struct JWTData: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}

struct ErrorData: Codable {
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }
}

struct ErrorResponse: Codable {
    let message: String
    let status: Int
    let data: ErrorData?

    struct ErrorData: Codable {
        let password: [String]?
        let email: [String]?
    }
}

class LoginViewController: UIViewController {
    let scrollView = UIScrollView()
    let mainView = UIView()
    let emailTextField = TextFieldWithPadding()
    let passwordTextField = TextFieldWithPadding()
    let titleLabel = UILabel()
    let leftLine = UIView()
    let rightLine = UIView()
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let tappedGuesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tappedGuesture)
    }

    @IBAction func dismissKeyboard() {
        view.endEditing(true)
    }

    func setupUI() {
        view.backgroundColor = UIColor(hex: "#F6F5F5")
        
        // Set up scroll view constraints
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Set up main view constraints
        mainView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            mainView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        let heightConstraint = mainView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        heightConstraint.priority = UILayoutPriority(250)
        heightConstraint.isActive = true
        
        // Image
        let logoImage = UIImageView(image: UIImage(named: "TravelAppLogo"))
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(logoImage)
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 80),
            logoImage.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            logoImage.heightAnchor.constraint(equalToConstant: 100),
            logoImage.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        // Title Label
        titleLabel.text = "Welcome Back!"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20)
        ])
        
        // Detail Label
        let detailLabel = UILabel()
        detailLabel.font = UIFont.systemFont(ofSize: 17)
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 0
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(detailLabel)
        detailLabel.text = "Stay signed in with your account to make searching easier"
        NSLayoutConstraint.activate([
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            detailLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 20),
            detailLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -20)
        ])
        
        // Email Label
        let emailLabel = UILabel()
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.font = UIFont.systemFont(ofSize: 15)
        emailLabel.text = "Email"
        mainView.addSubview(emailLabel)
        NSLayoutConstraint.activate([
            emailLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            emailLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 20)
        ])
        
        // Email Text Field

        emailTextField.borderColor = UIColor(hex: "#BFBFBF")
        emailTextField.backgroundColor = UIColor.white
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
        
        // Password Label
        let passwordLabel = UILabel()
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.font = UIFont.systemFont(ofSize: 15)
        passwordLabel.text = "Password"
        mainView.addSubview(passwordLabel)
        NSLayoutConstraint.activate([
            passwordLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10)
        ])
        
        // Password Text Field
//        passwordTextField.borderStyle = .roundedRect
//        passwordTextField.borderColor = .blue
        passwordTextField.borderColor = UIColor(hex: "#BFBFBF")
        passwordTextField.backgroundColor = .white
        passwordTextField.placeholder = "Enter your password"
        passwordTextField.font = UIFont.systemFont(ofSize: 15)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.enablePasswordToggle()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 10),
            passwordTextField.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 20),
            passwordTextField.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Radio Button
        let radioButton = RadioButton()
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(radioButton)
        NSLayoutConstraint.activate([
            radioButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8),
            radioButton.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 20),
            radioButton.widthAnchor.constraint(equalToConstant: 30),
            radioButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        let radioLabel = UILabel()
        radioLabel.text = "Keep me signed in"
        radioLabel.translatesAutoresizingMaskIntoConstraints = false
        radioLabel.font = UIFont.systemFont(ofSize: 11)
        mainView.addSubview(radioLabel)
        NSLayoutConstraint.activate([
            radioLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            radioLabel.leftAnchor.constraint(equalTo: radioButton.rightAnchor, constant: 5)
        ])
        
        // Forgot Password Label
        let forgotPasswordLabel = UILabel()
        forgotPasswordLabel.text = "Forgot password?"
        forgotPasswordLabel.font = UIFont.systemFont(ofSize: 13)
        forgotPasswordLabel.isUserInteractionEnabled = true
        forgotPasswordLabel.textColor = .red
        forgotPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(forgotPasswordLabel)
        NSLayoutConstraint.activate([
            forgotPasswordLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -20),
            forgotPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15)
        ])
        let forgotPassword = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordTapped))
        forgotPasswordLabel.addGestureRecognizer(forgotPassword)
        
        // Login Button
        let loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = UIColor(hex: "080E1E")
        loginButton.layer.cornerRadius = 10
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
            loginButton.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 20),
            loginButton.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        loginButton.addTarget(self, action: #selector(loginBtnTapped), for: .touchUpInside)
        
        // Separator Line and Label
        
        leftLine.backgroundColor = UIColor(hex: "64646E")
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        
        rightLine.backgroundColor = UIColor(hex: "64646E")
        rightLine.translatesAutoresizingMaskIntoConstraints = false

        label.text = "or continue with"
        label.textAlignment = .center
        label.textColor = UIColor(hex: "64646E")
        label.translatesAutoresizingMaskIntoConstraints = false
                
        mainView.addSubview(leftLine)
        mainView.addSubview(rightLine)
        mainView.addSubview(label)
                
        NSLayoutConstraint.activate([
            leftLine.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            leftLine.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -5),
            leftLine.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 40),
            leftLine.heightAnchor.constraint(equalToConstant: 1)
        ])
                
        NSLayoutConstraint.activate([
            rightLine.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 40),
            rightLine.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 5),
            rightLine.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            rightLine.heightAnchor.constraint(equalToConstant: 1)
        ])
                
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 25),
            label.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)
        ])
        
        // Social Media Icons
        let facebookImage = UIImageView(image: UIImage(named: "with facebook"))
        let twitterImage = UIImageView(image: UIImage(named: "with twitter"))
        let googleImage = UIImageView(image: UIImage(named: "with google"))
        
        mainView.addSubview(facebookImage)
        mainView.addSubview(twitterImage)
        mainView.addSubview(googleImage)
        
        facebookImage.isUserInteractionEnabled = true
        googleImage.isUserInteractionEnabled = true
        twitterImage.isUserInteractionEnabled = true
        
        facebookImage.translatesAutoresizingMaskIntoConstraints = false
        twitterImage.translatesAutoresizingMaskIntoConstraints = false
        googleImage.translatesAutoresizingMaskIntoConstraints = false
        
        // Google Image
        NSLayoutConstraint.activate([
            googleImage.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 50),
            googleImage.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            googleImage.widthAnchor.constraint(equalToConstant: 50),
            googleImage.heightAnchor.constraint(equalToConstant: 50)
        ])
        let googleTapped = UITapGestureRecognizer(target: self, action: #selector(withGoogle))
        googleImage.addGestureRecognizer(googleTapped)
        
        // Facebook Image
        NSLayoutConstraint.activate([
            facebookImage.rightAnchor.constraint(equalTo: googleImage.leftAnchor, constant: -15),
            facebookImage.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 50),
            facebookImage.widthAnchor.constraint(equalToConstant: 50),
            facebookImage.heightAnchor.constraint(equalToConstant: 50)
        ])
        let facebookTapped = UITapGestureRecognizer(target: self, action: #selector(withFacebook))
        facebookImage.addGestureRecognizer(facebookTapped)
        
        // Twitter Image
        NSLayoutConstraint.activate([
            twitterImage.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 50),
            twitterImage.leftAnchor.constraint(equalTo: googleImage.rightAnchor, constant: 15),
            twitterImage.widthAnchor.constraint(equalToConstant: 50),
            twitterImage.heightAnchor.constraint(equalToConstant: 50)
        ])
        let twittersTapped = UITapGestureRecognizer(target: self, action: #selector(withTwitter))
        twitterImage.addGestureRecognizer(twittersTapped)
        
        // Sign Up Section
        let questionLabel = UILabel()
        questionLabel.text = "You don't have an account?"
        questionLabel.textAlignment = .right
        questionLabel.font = UIFont.systemFont(ofSize: 13)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let signupLabel = UILabel()
        signupLabel.text = "SignUp"
        signupLabel.font = UIFont.systemFont(ofSize: 13)
        signupLabel.textColor = .red
        signupLabel.textAlignment = .left
        signupLabel.isUserInteractionEnabled = true
        signupLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let signUpStackView = UIStackView(arrangedSubviews: [questionLabel, signupLabel])
        signUpStackView.axis = .horizontal
        signUpStackView.spacing = 5
        signUpStackView.alignment = .center
        signUpStackView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(signUpStackView)
        
        NSLayoutConstraint.activate([
            signUpStackView.topAnchor.constraint(equalTo: googleImage.bottomAnchor, constant: 30),
            signUpStackView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            signUpStackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
        
        let signup = UITapGestureRecognizer(target: self, action: #selector(signUp))
        signupLabel.addGestureRecognizer(signup)
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true, completion: nil)
    }

        @objc func forgotPasswordTapped() {
            print("forgot password label")
            let viewController = ForgetPasswordViewController()
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }

        @IBAction func signUp() {
            let viewController = SignUpViewController()
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
            print("Sign up")
        }
    
        @IBAction func loginBtnTapped(_ sender: Any) {
            guard let email = emailTextField.text, !email.isEmpty,
                  let password = passwordTextField.text, !password.isEmpty else {
                showAlert(title: "Error", message: "Please enter both email and password.")
                
                return
            }
            let loadingiewController = LoadingViewController()
            present(loadingiewController, animated: true)
            login(email: email, password: password)
        }
        
        private func login(email: String, password: String) {
            let url = URL(string: "http://localhost:3000/auth/login")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.timeoutInterval = 30.0
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let bodyData = ["email": email, "password": password]
            request.httpBody = try? JSONSerialization.data(withJSONObject: bodyData, options: [])
            
            let urlSession = URLSession(configuration: .ephemeral)
            let task = urlSession.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        if let error = error {
                            self.showAlert(title: "Error", message: error.localizedDescription)  
                            return
                        }
                        guard let httpResponse = response as? HTTPURLResponse else {
                            self.showAlert(title: "Error", message: "Invalid response from server.")
                            return
                        }
                        if httpResponse.statusCode == 401 {
                            self.showAlert(title: "Error", message: "Unauthorized request.")
                            return
                        } else if httpResponse.statusCode == 422 {
                            guard let data = data else {
                                self.showAlert(title: "Error", message: "No data received.")
                                return
                            }
                            do {
                                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                                DispatchQueue.main.async {
                                    if let passwordErrors = errorResponse.data?.password {
                                        let errorMessage = passwordErrors.joined(separator: "\n")
                                        self.showAlert(title: "Error", message: errorMessage)
                                    } else if let emailErrors = errorResponse.data?.email {
                                        let errorMessage = emailErrors.joined(separator: "\n")
                                        self.showAlert(title: "Error", message: errorMessage)
                                    } else {
                                        self.showAlert(title: "Error", message: "Validation error: \(errorResponse.message)")
                                    }
                                }
                            } catch {
                                DispatchQueue.main.async {
                                    self.showAlert(title: "Error", message: error.localizedDescription)
                                }
                            }
                            return
                        }
                        guard let data = data else {
                            DispatchQueue.main.async {
                                self.showAlert(title: "Error", message: "No data received.")
                            }
                            return
                        }
                        
                        do {
                            let responseData = try JSONDecoder().decode(ResponseData.self, from: data)
                            DispatchQueue.main.async {
                                
                                switch responseData.data {
                                
                                case .jwt(_):
                                    UserDefaults.standard.set(true, forKey: "isUserLogged")
                                    let viewController = HomeTabbarViewController()
                                    viewController.modalTransitionStyle = .coverVertical
                                    viewController.modalPresentationStyle = .fullScreen
                                    self.present(viewController, animated: true)
                                case .error(let errorData):
                                    self.showAlert(title: "Error", message: errorData.message)
                                }
                            }
                        } catch let decodingError {
                            DispatchQueue.main.async {
                                self.showAlert(title: "Error", message: decodingError.localizedDescription)
                            }
                        }
                    }
                }
            }
            task.resume()
        }
        
    @objc func withFacebook() {
            print("login with facebook")
        }

    @objc func withGoogle() {
            print("login with google")
        }

    @objc func withTwitter() {
            print("login with twitter")
        }
    }
