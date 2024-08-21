import UIKit

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: NotificationsDelegate?

    let tableView = UITableView()
    var notifications: [NotificationModel] = []
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        fetchNotifications()
        startAutoUpdate()
        deleteNotificationsOlderThanOneWeek()
        updateNotificationBadge()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAutoUpdate()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NotificationCell")
        tableView.frame = view.bounds
    }

    private func fetchNotifications() {
        // Fetch and update notifications
        notifications = [
            NotificationModel(id: UUID(), date: Date().addingTimeInterval(-3600), message: "Message from an hour ago.", isRead: false),
            NotificationModel(id: UUID(), date: Date().addingTimeInterval(-86400), message: "Message from yesterday.", isRead: true),
            NotificationModel(id: UUID(), date: Date().addingTimeInterval(-604800), message: "Message from last week.", isRead: false)
        ]
        notifications.sort { $0.date > $1.date }
        tableView.reloadData()
        updateNotificationBadge()
    }

    func addNotification(date: Date, message: String) {
        let newNotification = NotificationModel(id: UUID(), date: date, message: message, isRead: false)
        notifications.append(newNotification)
        notifications.sort { $0.date > $1.date }
        tableView.reloadData()
        updateNotificationBadge()
    }

    func markNotificationAsRead(at index: Int) {
        notifications[index].isRead = true
        updateNotificationBadge()
    }

    func countUnreadNotifications() -> Int {
        return notifications.filter { !$0.isRead }.count
    }

    func updateNotificationBadge() {
        let unreadCount = countUnreadNotifications()
        NotificationCenter.default.post(name: .didUpdateNotificationBadge, object: nil, userInfo: ["count": unreadCount])
    }

    func deleteOldNotifications(olderThan date: Date) {
        notifications.removeAll { $0.date < date }
        tableView.reloadData()
        updateNotificationBadge()
    }

    func deleteNotificationsOlderThanOneWeek() {
        let oneWeekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        deleteOldNotifications(olderThan: oneWeekAgo)
    }

    func startAutoUpdate() {
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            self?.fetchNotifications()
        }
    }

    func stopAutoUpdate() {
        timer?.invalidate()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)
        let notification = notifications[indexPath.row]
        cell.textLabel?.text = notification.message
        cell.textLabel?.textColor = notification.isRead ? .gray : .black
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        markNotificationAsRead(at: indexPath.row)
        tableView.reloadData()
    }
}

extension Notification.Name {
    static let didUpdateNotificationBadge = Notification.Name("didUpdateNotificationBadge")
}
