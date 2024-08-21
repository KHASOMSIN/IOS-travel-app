import UIKit

class PlanDetailViewController: UIViewController {

    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var informationDetail: UIView!
    @IBOutlet weak var totalView: UIView!

    @IBOutlet weak var memberTripLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var titleDetail: UILabel!

    @IBOutlet weak var totalPriceslabel: UILabel!
    @IBOutlet weak var totalQuantityLabel: UILabel!
    @IBOutlet weak var totalItemLabel: UILabel!
    
    let additemhalfSreen = HalfModalTransitioningDelegate()
    var travelPlan: TravelPlan!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculateTotals()
        // Add shadow to the informationDetail view
        informationDetail.addShadow(color: .black, opacity: 0.3, radius: 10)

        itemTableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "ItemTableViewCell")
        
        // Set the data source and delegate
        itemTableView.dataSource = self
        itemTableView.delegate = self
        itemTableView.separatorStyle = .none
        itemTableView.backgroundColor = .clear
        itemTableView.reloadData()
        setupPlanDetail()
        
        // Add observer for notification
        NotificationCenter.default.addObserver(self, selector: #selector(planDetailUpdated), name: NSNotification.Name("PlanDetailUpdated"), object: nil)
    }
    
    deinit {
        // Remove observer when the view controller is deallocated
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("PlanDetailUpdated"), object: nil)
    }
    
    @objc func planDetailUpdated() {
        // Reload data to reflect changes
        itemTableView.reloadData()
        calculateTotals()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        itemTableView.reloadData()
        calculateTotals()
    }
    
    func setupPlanDetail() {
        titleDetail.text = travelPlan.planName
        locationLabel.text = travelPlan.placeName
        dateLabel.text = travelPlan.date
        memberTripLabel.text = travelPlan.tripMember
    }

    @IBAction func additemTapped(_ sender: Any) {
        navigateToAddPlanDetailViewController(planDetail: nil)
    }
    
    private func navigateToAddPlanDetailViewController(planDetail: PlanDetails?) {
        let viewController = AdditemsViewController()
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = additemhalfSreen
        viewController.planDetail = planDetail
        viewController.plan = travelPlan
        present(viewController, animated: true)
    }
    
    func showAlert(title: String, message: String, shouldClose: Bool = false) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            if shouldClose {
                self.dismiss(animated: true)
            }
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: calculate item
    func calculateTotals() {
        guard let planDetails = travelPlan.planDetail else {
            totalItemLabel.text = "0"
            totalQuantityLabel.text = "0"
            totalPriceslabel.text = "0"
            return
        }
        
        let sortedPlanDetails = Array(planDetails).sorted { $0.titleItems ?? "" < $1.titleItems ?? "" }
        
        // Calculate totals
        let totalItems = sortedPlanDetails.count
        let totalQuantity = sortedPlanDetails.reduce(0) { $0 + $1.amount }
        let totalPrices = sortedPlanDetails.reduce(0) { $0 + ($1.prices * Double($1.amount)) }
        
        // Update labels
        totalItemLabel.text = "Items : \(totalItems)"
        totalQuantityLabel.text = "Qty: \(totalQuantity)"
        totalPriceslabel.text = String(format: "%.2f$", totalPrices)
    }
}

extension PlanDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travelPlan.planDetail?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as! ItemTableViewCell
        
        if let planDetails = travelPlan.planDetail {
            let sortedPlanDetails = Array(planDetails).sorted { $0.titleItems ?? "" < $1.titleItems ?? "" }
            let planDetail = sortedPlanDetails[indexPath.row]
            
            cell.titleItemLabel.text = planDetail.titleItems
            cell.itemsLabel.text = "\(planDetail.amount) items"
            cell.priceLabel.text = "\(planDetail.prices)$"
        }
        
        return cell
    }
}

extension PlanDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, complete in
            guard let self = self else { return }
            
            let alertController = UIAlertController(title: "Confirmation", message: "Are you sure you want to remove this item?", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "OK", style: .destructive) { _ in
                self.deleteItem(at: indexPath)
                complete(true)
            }
            let noAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                complete(true)
            }
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            self.present(alertController, animated: true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, complete in
            guard let self = self else { return }
            if let sortedPlanDetails = self.travelPlan.planDetail?.sorted(by: { $0.titleItems ?? "" < $1.titleItems ?? "" }) {
                let planDetail = sortedPlanDetails[indexPath.row]
                self.navigateToAddPlanDetailViewController(planDetail: planDetail)
            }
            complete(true)
        }
        editAction.backgroundColor = .systemGreen
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    private func deleteItem(at indexPath: IndexPath) {
        guard let planDetails = travelPlan.planDetail else { return }
        
        let sortedPlanDetails = Array(planDetails).sorted { $0.titleItems ?? "" < $1.titleItems ?? "" }
        let planDetailToDelete = sortedPlanDetails[indexPath.row]
        
        // Delete the item from Core Data
        let context = CoreDataManager.shared.context
        context.delete(planDetailToDelete)
        
        // Save the context
        do {
            try context.save()
            itemTableView.reloadData()
            calculateTotals()
        } catch {
            print("Failed to delete item: \(error)")
            showAlert(title: "Error", message: "Failed to delete item")
        }
    }
}
