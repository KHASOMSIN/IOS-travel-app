//
//  RegistrationComplatedViewController.swift
//  Tavel
//
//  Created by user245540 on 7/20/24.
//

import UIKit

class RegistrationComplatedViewController: UIViewController {
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI(){
        view.backgroundColor = UIColor(hex: "#FFFFFF")
        
        let mainView = UIView()
        view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            mainView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Logo image setup
        let logoImage = UIImageView(image: UIImage(named: "Completed"))
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImage.heightAnchor.constraint(equalToConstant: 80),
            logoImage.widthAnchor.constraint(equalToConstant: 80),
            
        ])
        
        // Title label setup
        titleLabel.text = "Done"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Detail label setup
        detailLabel.font = UIFont.systemFont(ofSize: 17)
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 0
        detailLabel.text = "You have successfully completed your registration"
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Stack view for logo, title, and detail labels
        let stackView = UIStackView(arrangedSubviews: [logoImage, titleLabel, detailLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),  
            stackView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20)
        ])
        
        // button go to login
        let loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = UIColor(hex: "#080E1E")
        loginButton.layer.cornerRadius = 10
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(loginButton)
        NSLayoutConstraint.activate([
//            verfyButton.topAnchor.constraint(equalTo: expiretimeStackView.bottomAnchor, constant: 200),
            loginButton.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 20),
            loginButton.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -30)
        ])
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }

}
extension RegistrationComplatedViewController{
    @IBAction func loginTapped(_ sender: UIButton){
        let loginViewController = LoginViewController()
        loginViewController.modalPresentationStyle = .fullScreen
        self.present(loginViewController, animated: true)
        
    }
}
