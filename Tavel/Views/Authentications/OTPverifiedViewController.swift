import UIKit
import Alamofire

// Define the struct for OTP response
struct OTPResponse: Codable {
    let status: Int
    let message: String
    let data: OTPData?
}

// Define the struct for OTP data, if needed
struct OTPData: Codable {
    let message: String
}

class OTPverifiedViewController: UIViewController, UITextFieldDelegate {
    let mainView = UIView()
    var otpTextField1 = UITextField()
    var otpTextField2 = UITextField()
    var otpTextField3 = UITextField()
    var otpTextField4 = UITextField()
    let numberLoading = UILabel()
    let resendCode = UILabel()
    let activityIndicator = UIActivityIndicatorView()
    let email = DataManager.shared.email ?? ""

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

    // Countdown Timer Methods
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

    // Setup UI for the view controller
    func setupUI() {
        view.backgroundColor = UIColor(hex: "#F5F7F8")

        // Main view setup
        mainView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            mainView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])

        // Logo image setup
        let logoImage = UIImageView(image: UIImage(named: "CheckYourEmail"))
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImage.heightAnchor.constraint(equalToConstant: 85),
            logoImage.widthAnchor.constraint(equalToConstant: 55.41)
        ])

        // Title label setup
        let titleLabel = UILabel()
        titleLabel.text = "Check Your Email"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Detail label setup
        let detailLabel = UILabel()
        detailLabel.font = UIFont.systemFont(ofSize: 17)
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 0
        detailLabel.text = "We’ve sent the code to the email on your device"
        detailLabel.translatesAutoresizingMaskIntoConstraints = false

        // Stack view for logo, title, and detail labels
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

        // OTP TextFields setup
        setupText(otpTextField1)
        setupText(otpTextField2)
        setupText(otpTextField3)
        setupText(otpTextField4)

        // Stack view for OTP text fields
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

        // Expiry label setup
        let expireInLabel = UILabel()
        mainView.addSubview(expireInLabel)
        expireInLabel.translatesAutoresizingMaskIntoConstraints = false
        expireInLabel.text = "Code expires in:"
        expireInLabel.font = UIFont.systemFont(ofSize: 13)

        // Number loading label
        mainView.addSubview(numberLoading)
        numberLoading.translatesAutoresizingMaskIntoConstraints = false
        numberLoading.text = "0:00"
        numberLoading.textColor = .red
        numberLoading.font = UIFont.systemFont(ofSize: 13)

        // Stack view for expiry labels
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

        // Resend code label setup
        let notReceiveCode = UILabel()
        mainView.addSubview(notReceiveCode)
        notReceiveCode.translatesAutoresizingMaskIntoConstraints = false
        notReceiveCode.font = UIFont.systemFont(ofSize: 13)
        notReceiveCode.text = "Didn’t receive code?"

        mainView.addSubview(resendCode)
        resendCode.translatesAutoresizingMaskIntoConstraints = false
        resendCode.font = UIFont.systemFont(ofSize: 13)
        resendCode.text = "Resend Code"
        resendCode.isUserInteractionEnabled = true
        resendCode.textColor = .red
        let codeTapGesture = UITapGestureRecognizer(target: self, action: #selector(resentCodeTapped))
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

        // Verify button setup
        let verifyButton = UIButton()
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

    // TextField setup method
    func setupText(_ textField: UITextField) {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.font = UIFont.boldSystemFont(ofSize: 34)
        textField.textAlignment = .center
        textField.keyboardType = .numberPad
        textField.textContentType = .oneTimeCode
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 10
        NSLayoutConstraint.activate([
            textField.widthAnchor.constraint(equalToConstant: 60),
            textField.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    // TextField change handler
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text

        if text?.utf16.count == 1 {
            switch textField {
            case otpTextField1:
                otpTextField2.becomeFirstResponder()
            case otpTextField2:
                otpTextField3.becomeFirstResponder()
            case otpTextField3:
                otpTextField4.becomeFirstResponder()
            case otpTextField4:
                otpTextField4.resignFirstResponder()
            default:
                break
            }
        }
    }

    // Verify Button Tap Handler
    @objc func verifyBtnTapped() {
        let otpCode = "\(otpTextField1.text ?? "")\(otpTextField2.text ?? "")\(otpTextField3.text ?? "")\(otpTextField4.text ?? "")"
        if otpCode.count == 4 {
            verifyOtp(email: email, otpCode: otpCode)
        } else {
            showAlert(title: "Error", message: "Please enter a valid 4-digit OTP code.")
        }
    }

    // OTP Verification Function
    func verifyOtp(email: String, otpCode: String) {
        let url = "https://travel-flame-ten.vercel.app/auth/verify"
        let parameters: [String: Any] = [
            "email": email,
            "otp": otpCode
        ]
        print(email)
        print(otpCode)
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: OTPResponse.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let otpResponse):
                        if otpResponse.status == 200 {
                            self.showAlert(title: "Success", message: otpResponse.data?.message ?? "OTP verified successfully.", completion: {
                                let viewController = RegistrationComplatedViewController()
                                viewController.modalPresentationStyle = .fullScreen
                                viewController.modalTransitionStyle = .coverVertical
                                self.present(viewController, animated: true)
                            })
                        } else {
                            self.showAlert(title: "Error", message: otpResponse.message)
                        }
                    case .failure(let error):
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    }
                }
            }
    }

    // Resend Code Tap Handler
    @objc func resentCodeTapped() {
        if numberLoading.text != "Code expired!" {
            showAlert(title: "Error", message: "OTP code not expired yet. Please try again later.")
        } else {
            resendOtp(email: email)
            resendCode.isUserInteractionEnabled = false // Disable the resend button
        }
    }

    // Resend OTP Function
    func resendOtp(email: String) {
        let url = "https://travel-flame-ten.vercel.app/auth/resend-otp"
        let parameters: [String: Any] = [
            "email": email
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: OTPResponse.self) { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let otpResponse):
                        if otpResponse.status == 200 {
                            self.showAlert(title: "Success", message: "OTP resent successfully.")
                            self.countdownTime = 300
                            self.startCountdown()
                        } else {
                            self.showAlert(title: "Error", message: otpResponse.message)
                        }
                    case .failure(let error):
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    }
                    self.resendCode.isUserInteractionEnabled = true // Re-enable the resend button
                }
            }
    }

    // Show Alert Method
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
