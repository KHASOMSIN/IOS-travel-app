import UIKit
import Alamofire

class OTPverifiedViewController: UIViewController, UITextFieldDelegate {
    
    // UI Components
    let mainView = UIView()
    var otpTextField1 = UITextField()
    var otpTextField2 = UITextField()
    var otpTextField3 = UITextField()
    var otpTextField4 = UITextField()
    let numberLoading = UILabel()
    let resendCode = UILabel()
    
    let email = DataManager.shared.email ?? "nil"
    var loadingViewController: UIViewController!

    // Timer Properties
    var timer: Timer?
    var countdownTime: Int = 300

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startCountdown()
    }

    deinit {
        timer?.invalidate()
    }

    // MARK: - Countdown Timer Methods
    func startCountdown() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }

    @objc func updateCountdown() {
        if countdownTime > 0 {
            countdownTime -= 1
            updateCountdownLabel()
        } else {
            timer?.invalidate()
            timer = nil
            countdownFinished()
        }
    }

    func updateCountdownLabel() {
        let minutes = countdownTime / 60
        let seconds = countdownTime % 60
        numberLoading.text = String(format: "%02d:%02d", minutes, seconds)
    }

    func countdownFinished() {
        numberLoading.text = "Code expired!"
    }

    // MARK: - Setup UI
    func setupUI() {
        view.backgroundColor = UIColor(hex: "#F5F7F8")

        // Main View Setup
        mainView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            mainView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])

        // Stack View for Logo, Title, and Detail Labels
        let logoImage = createLogoImageView()
        let titleLabel = createLabel(text: "Check Your Email", fontSize: 24, isBold: true, alignment: .center)
        let detailLabel = createLabel(text: "We’ve sent the code to the email on your device", fontSize: 17, alignment: .center, numberOfLines: 0)
        
        let stackView = UIStackView(arrangedSubviews: [logoImage, titleLabel, detailLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20)
        ])

        // OTP TextFields Setup
        setupText(otpTextField1)
        setupText(otpTextField2)
        setupText(otpTextField3)
        setupText(otpTextField4)

        let stackViewTextField = UIStackView(arrangedSubviews: [otpTextField1, otpTextField2, otpTextField3, otpTextField4])
        stackViewTextField.axis = .horizontal
        stackViewTextField.alignment = .center
        stackViewTextField.distribution = .equalSpacing
        stackViewTextField.spacing = 0
        stackViewTextField.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(stackViewTextField)

        NSLayoutConstraint.activate([
            stackViewTextField.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 50),
            stackViewTextField.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            stackViewTextField.widthAnchor.constraint(equalToConstant: 270),
            stackViewTextField.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Expiry Label Setup
        let expireInLabel = createLabel(text: "Code expires in:", fontSize: 13)
        mainView.addSubview(expireInLabel)
        
        numberLoading.text = "0:00"
        numberLoading.textColor = .red
        numberLoading.font = UIFont.systemFont(ofSize: 13)
        mainView.addSubview(numberLoading)

        let expiretimeStackView = UIStackView(arrangedSubviews: [expireInLabel, numberLoading])
        expiretimeStackView.axis = .horizontal
        expiretimeStackView.spacing = 5
        expiretimeStackView.alignment = .center
        expiretimeStackView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(expiretimeStackView)

        NSLayoutConstraint.activate([
            expiretimeStackView.topAnchor.constraint(equalTo: stackViewTextField.bottomAnchor, constant: 50),
            expiretimeStackView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)
        ])

        // Resend Code Label Setup
        let notReceiveCode = createLabel(text: "Didn’t receive code?", fontSize: 13)
        resendCode.text = "Resend Code"
        resendCode.font = UIFont.systemFont(ofSize: 13)
        resendCode.textColor = .red
        resendCode.isUserInteractionEnabled = true
        let codeTapGesture = UITapGestureRecognizer(target: self, action: #selector(resendCodeTapped))
        resendCode.addGestureRecognizer(codeTapGesture)

        let resCodeStackView = UIStackView(arrangedSubviews: [notReceiveCode, resendCode])
        resCodeStackView.axis = .horizontal
        resCodeStackView.spacing = 5
        resCodeStackView.alignment = .center
        resCodeStackView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(resCodeStackView)

        NSLayoutConstraint.activate([
            resCodeStackView.topAnchor.constraint(equalTo: expiretimeStackView.bottomAnchor, constant: 15),
            resCodeStackView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)
        ])

        // Verify Button Setup
        let verifyButton = UIButton(type: .system)
        verifyButton.setTitle("Verify", for: .normal)
        verifyButton.setTitleColor(.white, for: .normal)
        verifyButton.backgroundColor = UIColor(hex: "#080E1E")
        verifyButton.layer.cornerRadius = 10
        verifyButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        verifyButton.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(verifyButton)
        NSLayoutConstraint.activate([
            verifyButton.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 20),
            verifyButton.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -20),
            verifyButton.heightAnchor.constraint(equalToConstant: 50),
            verifyButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -30)
        ])
        verifyButton.addTarget(self, action: #selector(verifyBtnTapped), for: .touchUpInside)

        // Assign delegate and target for text fields
        otpTextField1.delegate = self
        otpTextField2.delegate = self
        otpTextField3.delegate = self
        otpTextField4.delegate = self

        otpTextField1.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        otpTextField2.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        otpTextField3.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        otpTextField4.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        updateCountdownLabel()
    }

    // MARK: - Helper Methods for Creating UI Components
    func createLabel(text: String, fontSize: CGFloat, isBold: Bool = false, alignment: NSTextAlignment = .left, numberOfLines: Int = 1) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        label.textAlignment = alignment
        label.numberOfLines = numberOfLines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func createLogoImageView() -> UIImageView {
        let logoImageView = UIImageView(image: UIImage(named: "CheckYourEmail"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: 85),
            logoImageView.widthAnchor.constraint(equalToConstant: 55.41)
        ])
        return logoImageView
    }

    // TextField setup method
    func setupText(_ textField: UITextField) {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.font = UIFont.boldSystemFont(ofSize: 28)
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.textContentType = .oneTimeCode
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hex: "#080E1E").cgColor
        textField.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }

    // MARK: - OTP Validation
    @objc func verifyBtnTapped() {
        guard let otp1 = otpTextField1.text, let otp2 = otpTextField2.text,
              let otp3 = otpTextField3.text, let otp4 = otpTextField4.text else {
            showAlert(title: "Error", message: "Please fill in all OTP fields.")
            return
        }
        loadingViewController = LoadingViewController()
        present(loadingViewController, animated: true)
        let otpCode = otp1 + otp2 + otp3 + otp4
        verifyOtp(otpCode)
    }

    @objc func textFieldDidChange(textField: UITextField) {
        switch textField {
        case otpTextField1:
            if textField.text?.count == 1 {
                otpTextField2.becomeFirstResponder()
            }
        case otpTextField2:
            if textField.text?.count == 1 {
                otpTextField3.becomeFirstResponder()
            } else {
                otpTextField1.becomeFirstResponder()
            }
        case otpTextField3:
            if textField.text?.count == 1 {
                otpTextField4.becomeFirstResponder()
            } else {
                otpTextField2.becomeFirstResponder()
            }
        case otpTextField4:
            if textField.text?.count == 0 {
                otpTextField3.becomeFirstResponder()
            }
        default:
            break
        }
    }
    // MARK: - API Calls
    func verifyOtp(_ otpCode: String) {
        let parameters: [String: String] = ["email": email, "otp": otpCode]
        AF.request("\(urlLocal)auth/verify", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            self.loadingViewController.dismiss(animated: true) {
                switch response.result {
                case .success(let value):
                    print("Response Data: \(value)") // Debugging output
                    if let json = value as? [String: Any], let status = json["status"] as? Int {
                        if status == 200 {
                            let viewController = RegistrationComplatedViewController()
                            viewController.modalPresentationStyle = .fullScreen
                            self.present(viewController, animated: true)
                        } else {
                            let message = json["message"] as? String ?? "Unknown error"
                            self.showAlert(title: "Error", message: message)
                        }
                    } else {
                        self.showAlert(title: "Error", message: "Invalid response format")
                    }
                case .failure(let error):
                    print("Request Error: \(error)") // Debugging output
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }

    @objc func resendCodeTapped() {
        let parameters: [String: String] = ["email": email]
        
        AF.request("http://localhost:3000/auth/resend-otp", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Response Data: \(value)") // Debugging output
                if let json = value as? [String: Any], let status = json["status"] as? Int {
                    if status == 200 {
                        self.showAlert(title: "Success", message: "OTP resent successfully. Please check your email.")
                        self.countdownTime = 300 // Reset countdown time
                        self.startCountdown() // Restart the countdown
                        self.resendCode.isUserInteractionEnabled = false // Disable the resend button until code expires
                    } else {
                        let message = json["message"] as? String ?? "Unknown error"
                        self.showAlert(title: "Error", message: message)
                    }
                } else {
                    self.showAlert(title: "Error", message: "Invalid response format")
                }
            case .failure(let error):
                print("Request Error: \(error)") // Debugging output
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }


    // Helper function to show alert
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        self.present(alert, animated: true)
    }
}
