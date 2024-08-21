import UIKit
import Localize_Swift

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var settingTableView: UITableView!
    
    var users: [userProfile] = [
        userProfile(profileImage: "AccountProfiles", name: "Kha Sin")
    ]
    
    var settings: [settingOption] = [
        settingOption(iconImage: "Languages", name: "Change Language".localized()),
        settingOption(iconImage: "change-password", name: "Change Password".localized()),
        settingOption(iconImage: "Logout1", name: "Logout".localized())
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        settingTableView.dataSource = self
        settingTableView.delegate = self
        
        settingTableView.separatorStyle = .none
        
        // Register the nib for the custom cell
        let profileNib = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        profileTableView.register(profileNib, forCellReuseIdentifier: "ProfileTableViewCell")
        
        let settingNib = UINib(nibName: "SettingsTableViewCell", bundle: nil)
        settingTableView.register(settingNib, forCellReuseIdentifier: "SettingsTableViewCell")
        
        // Observe language change notifications
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    // Remove the observer when the view controller is deinitialized
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    @objc private func updateLanguage() {
        // Update the localized strings
        settings = [
            settingOption(iconImage: "Languages", name: "Change Language".localized()),
            settingOption(iconImage: "change-password", name: "Change Password".localized()),
            settingOption(iconImage: "Logout1", name: "Logout".localized())
        ]
        
        // Reload table view data to reflect changes
        settingTableView.reloadData()
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == profileTableView {
            return users.count
        } else {
            return settings.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == profileTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
            let user = users[indexPath.row]
            
            // Safely unwrap the optional profileImage
            if let profileImageName = user.profileImage {
                cell.profileImage.image = UIImage(named: profileImageName)
            } else {
                cell.profileImage.image = UIImage(named: "defaultProfileImage") // Fallback image
            }
            
            cell.nameLabel.text = user.name
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as!
            SettingsTableViewCell
            let setting = settings[indexPath.row]
            
            // Safely unwrap the optional iconImage
            if let iconName = setting.iconImage {
                cell.logoImage.image = UIImage(named: iconName)
            } else {
                cell.logoImage.image = UIImage(named: "defaultIconImage") // Fallback image
            }
            
            cell.titleSetting.text = setting.name
            return cell
        }
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == profileTableView {
            print("User Profile selected")
            let viewController = UserProfileViewController()
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            switch indexPath.row {
            case 0:
                print("Change Language selected")
                let viewController = ChangeLanguageViewController()
                navigationController?.pushViewController(viewController, animated: true)
            case 1:
                print("Reset Password selected")
                let viewController  = ChangePasswordViewController()
                navigationController?.pushViewController(viewController, animated: true)
            case 2:
                showAlert(
                    title: "update_title",
                    message: "update_message",
                    confirmTitle: "update_confirm",
                    cancelTitle: "update_cancel",
                    confirmHandler: {
                        UserDefaults.standard.removeObject(forKey: "isUserLogged")
                        let viewController  = LoginViewController()
                        viewController.modalPresentationStyle = .fullScreen
                        self.present(viewController, animated: true)
                        // Handle the log out process, e.g., navigate to login screen
                    }
                )
            default:
                break
            }
        }
    }
}


extension ProfileViewController {

    // Function to present a generic alert
    func showAlert(title: String, message: String, confirmTitle: String, cancelTitle: String? = "Cancel".localized(), confirmHandler: (() -> Void)? = nil, cancelHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title.localized(), message: message.localized(), preferredStyle: .alert)
        
        // Add Confirm Button
        let confirmAction = UIAlertAction(title: confirmTitle.localized(), style: .default) { _ in
            confirmHandler?()
        }
        alert.addAction(confirmAction)
        
        // Add Cancel Button
        if let cancelTitle = cancelTitle {
            let cancelAction = UIAlertAction(title: cancelTitle.localized(), style: .cancel) { _ in
                cancelHandler?()
            }
            alert.addAction(cancelAction)
        }
        
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
}


