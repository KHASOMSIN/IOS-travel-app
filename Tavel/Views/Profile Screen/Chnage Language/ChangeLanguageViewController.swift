import UIKit
import Localize_Swift
import SnapKit

class ChangeLanguageViewController: UIViewController {

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome".localized() // Ensure this key is present in your localization files
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    private let englishButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("English", for: .normal)
        button.addTarget(self, action: #selector(changeToEnglish), for: .touchUpInside)
        return button
    }()
    
    private let khmerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ខ្មែរ", for: .normal)
        button.addTarget(self, action: #selector(changeToKhmer), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(welcomeLabel)
        view.addSubview(englishButton)
        view.addSubview(khmerButton)
        
        welcomeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        englishButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(welcomeLabel.snp.bottom).offset(20)
        }
        
        khmerButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(englishButton.snp.bottom).offset(20)
        }
    }
    
    @objc private func changeToEnglish() {
        print("Changing to English")
        Localize.setCurrentLanguage("en")
        updateUIForCurrentLanguage()
    }
    
    @objc private func changeToKhmer() {
        print("Changing to Khmer")
        Localize.setCurrentLanguage("km")
        updateUIForCurrentLanguage()
    }
    
    private func updateUIForCurrentLanguage() {
        // Update UI elements with localized strings
        welcomeLabel.text = "Welcome".localized()
        englishButton.setTitle("English".localized(), for: .normal)
        khmerButton.setTitle("ខ្មែរ".localized(), for: .normal)
        // Update other UI elements as needed
    }
}
