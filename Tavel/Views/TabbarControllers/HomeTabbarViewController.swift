import UIKit

// Protocol to update the badge
protocol NotificationsDelegate: AnyObject {
    func updateNotificationBadge(count: Int)
}

class HomeTabbarViewController: UITabBarController, UITabBarControllerDelegate, NotificationsDelegate {

    // Define images
    let homeImage = UIImage(named: "Home")?.resize(to: CGSize(width: 24, height: 24))
    let homeSelectedImage = UIImage(named: "Home_selected")?.resize(to: CGSize(width: 24, height: 24))
    
    let savedImage = UIImage(named: "saved1")?.resize(to: CGSize(width: 24, height: 24))
    let savedSelectedImage = UIImage(named: "Heart_selected")?.resize(to: CGSize(width: 24, height: 24))
    
    let addTripImage = UIImage(named: "Plus")?.resize(to: CGSize(width: 24, height: 24))
    
    let notificationImage = UIImage(named: "Notification")?.resize(to: CGSize(width: 24, height: 24))
    let notificationSelectedImage = UIImage(named: "Notification_selected")?.resize(to: CGSize(width: 24, height: 24))
    
    let profileImage = UIImage(named: "Profile")?.resize(to: CGSize(width: 24, height: 24))
    let profileSelectedImage = UIImage(named: "Profile_selected")?.resize(to: CGSize(width: 24, height: 24))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self

        let homeVC = HomeViewController()
        let saveVC = SaveViewController()
        let addTripVC = AddTripViewController()
        let notificationVC = NotificationsViewController()
        let profileVC = ProfileViewController()

        // Set delegate
        notificationVC.delegate = self

        let homeNav = UINavigationController(rootViewController: homeVC)
        let saveNav = UINavigationController(rootViewController: saveVC)
        let addTripNav = UINavigationController(rootViewController: addTripVC)
        let notificationNav = UINavigationController(rootViewController: notificationVC)
        let profileNav = UINavigationController(rootViewController: profileVC)

        homeVC.tabBarItem = UITabBarItem(title: "Home", image: homeImage, selectedImage: homeSelectedImage)
        saveVC.tabBarItem = UITabBarItem(title: "Saved", image: savedImage, selectedImage: savedSelectedImage)
        addTripVC.tabBarItem = UITabBarItem(title: "Add Trip", image: addTripImage, selectedImage: addTripImage)
        notificationVC.tabBarItem = UITabBarItem(title: "Notifications", image: notificationImage, selectedImage: notificationSelectedImage)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: profileImage, selectedImage: profileSelectedImage)

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 10)!, NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 10)!, NSAttributedString.Key.foregroundColor: UIColor(hex: "34C98E")], for: .selected)

        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
        tabBar.tintColor = UIColor(hex: "34C98E")
        tabBar.unselectedItemTintColor = .black

        self.viewControllers = [homeNav, saveNav, addTripNav, notificationNav, profileNav]

        // Observe badge update notifications
        NotificationCenter.default.addObserver(self, selector: #selector(handleBadgeUpdate(_:)), name: .didUpdateNotificationBadge, object: nil)
    }

    @objc private func handleBadgeUpdate(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let count = userInfo["count"] as? Int else { return }
        updateNotificationBadge(count: count)
    }

    func updateNotificationBadge(count: Int) {
        guard let tabBarItems = tabBar.items, tabBarItems.count > 3 else { return }
        let notificationTabBarItem = tabBarItems[3] // Assuming Notifications is the 4th tab
        if count > 0 {
            notificationTabBarItem.badgeValue = "\(count)"
        } else {
            notificationTabBarItem.badgeValue = nil
        }
    }
}

extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    convenience init?(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
