import UIKit

class AdditemsViewController: UIViewController {

    @IBOutlet weak var addEditbtn: UIButton!
    @IBOutlet weak var pricesTextField: UITextField!
    @IBOutlet weak var amountTextFied: UITextField!
    @IBOutlet weak var itemsTitlesTextField: UITextField!
    
    var planDetail: PlanDetails?
    var plan: TravelPlan?
    var isEditMode: Bool {
        return planDetail != nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layer.cornerRadius = 16
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isEditMode {
            setupForEdit()
        } else {
            setupForCreate()
        }
    }
    
    func setupForEdit(){
        addEditbtn.setTitle("Edit items", for: .normal)
        if let existingPlanDetail = planDetail {
            itemsTitlesTextField.text = existingPlanDetail.titleItems
            amountTextFied.text = String(existingPlanDetail.amount)
            pricesTextField.text = String(existingPlanDetail.prices)
        }
    }
    
    func setupForCreate() {
        addEditbtn.setTitle("Add items", for: .normal)
        itemsTitlesTextField.text = ""
        amountTextFied.text = ""
        pricesTextField.text = ""
    }
    
    @IBAction func tapGestureTapped(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func addItemsTapped(_ sender: Any) {
        guard let title = itemsTitlesTextField.text, !title.isEmpty,
              let amountText = amountTextFied.text, !amountText.isEmpty,
              let priceText = pricesTextField.text, !priceText.isEmpty else {
            showAlert(title: "Entry Error", message: "Please provide all fields.")
            return
        }

        // Check if amount can be converted to Int and price can be converted to Double
        guard let amount = Int16(amountText), let price = Double(priceText) else {
            showAlert(title: "Entry Error", message: "Please provide valid numbers for amount and price.")
            return
        }
        
        let context = CoreDataManager.shared.context
        
        if isEditMode {
            if let existingPlan = planDetail {
                existingPlan.titleItems = title
                existingPlan.amount = amount
                existingPlan.prices = price
            }
        } else {
            let newItems = PlanDetails(context: context)
            newItems.titleItems = title
            newItems.amount = amount
            newItems.prices = price
            newItems.travelPlan = plan
            newItems.itemId = UUID().uuidString
        }
        
        do {
            try CoreDataManager.shared.save()
            NotificationCenter.default.post(name: NSNotification.Name("PlanDetailUpdated"), object: nil)
            if isEditMode {
                showAlert(title: "Item Updated", message: "Your item has been updated successfully.", shouldClose: true)
            } else {
                showAlert(title: "Item Added", message: "Your item has been added successfully.", shouldClose: true)
            }
        } catch {
            print("Failed to add items: \(error)")
            showAlert(title: "Error", message: "Failed to add items")
        }
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
}
