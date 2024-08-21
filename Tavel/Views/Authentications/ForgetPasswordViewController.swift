import UIKit
import SnapKit

class ForgetPasswordViewController: UIViewController {
    let scrollView = UIScrollView()
    let contenView = UIView()
    let backgroundViewLogo = UIView()
    let logoImage = UIImageView()
    let titleLabel = UILabel()
    let emailTextField = TextFieldWithPadding()
    let nextBtn = UIButton(type: .system)
    let closeBtn = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "C4C4C4")

        setupView()
        setConstraints()
    }
    
    private func setupView(){
        view.addSubview(scrollView)
        scrollView.addSubview(contenView)
        
        contenView.addSubview(backgroundViewLogo)
        backgroundViewLogo.backgroundColor = .white.withAlphaComponent(0.8)
        backgroundViewLogo.layer.cornerRadius = 50
        
        backgroundViewLogo.addSubview(logoImage)
        logoImage.image = UIImage(named: "AppIcon")?.resize(to: CGSize(width: 80, height: 80))
        logoImage.layer.cornerRadius = 40
        logoImage.clipsToBounds = true
        
        contenView.addSubview(titleLabel)
        titleLabel.text = "Forgot Your Password"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        
        contenView.addSubview(emailTextField)
        emailTextField.placeholder = "Enter your email"
        emailTextField.setupLeftIcon(UIImage(named: "email")?.resize(to: CGSize(width: 24, height: 24)))
        emailTextField.borderStyle = .roundedRect
        emailTextField.borderColor = .black.withAlphaComponent(0.3)
        
        contenView.addSubview(nextBtn)
        nextBtn.setTitle("Next", for: .normal)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.backgroundColor = .black
        nextBtn.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        nextBtn.layer.cornerRadius = 10
        
        contenView.addSubview(closeBtn)
        closeBtn.setTitle("Close", for: .normal)
        closeBtn.addTarget(self, action: #selector(closebtnTapped), for: .touchUpInside)
    }
    
    @objc func closebtnTapped() {
        print("Close")
        self.dismiss(animated: true)
    }
    @objc func nextTapped() {
        
    }
    
    // MARK: setContraint()
    private func setConstraints(){
        // scroll view setup
        scrollView.snp.makeConstraints {make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        // content view set constraint
        contenView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(scrollView.frameLayoutGuide).priority(.low)
        }
        
        // set background View
        backgroundViewLogo.snp.makeConstraints { make in
            make.top.equalTo(contenView.snp.top).offset(100)
            make.centerX.equalTo(contenView.snp.centerX)
            make.height.width.equalTo(100)
        }
        
        logoImage.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(backgroundViewLogo)
            make.height.width.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundViewLogo.snp.bottom).offset(20)
            make.trailing.equalTo(contenView.snp.trailing).offset(-20)
            make.leading.equalTo(contenView.snp.leading).offset(20)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
            make.trailing.equalTo(contenView.snp.trailing).offset(-20)
            make.leading.equalTo(contenView.snp.leading).offset(20)
        }
        
        nextBtn.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(50)
            make.trailing.equalTo(contenView.snp.trailing).offset(-20)
            make.leading.equalTo(contenView.snp.leading).offset(20)
            make.height.equalTo(50)
            make.bottom.greaterThanOrEqualTo(contenView.snp.bottom).offset(-10)
            
        }
        closeBtn.snp.makeConstraints { make in
            make.top.equalTo(contenView.snp.top)
            make.right.equalTo(contenView.snp.right).offset(-10)
        }
        
    }
}
