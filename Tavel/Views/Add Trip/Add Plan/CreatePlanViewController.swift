import UIKit
import CoreData
import SnapKit

class CreatePlanViewController: UIViewController, AddPlaceDelegate, AddDateDelegate{

    var numberOfPeople = 1
    let peopleNumber = UILabel()
    let contentView = UIView()
    let locationName = UILabel()  // Add this property
    let dateLabel = UILabel()
    let createTripBtn = UIButton()
    let scrollView = UIScrollView()
    let tripNameTextField = TextFieldWithPadding()

    let halfPresentaion = HalfModalTransitioningDelegate()
    var travelPlan: TravelPlan?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
        addContentToScrollView()
        setupCustomBackButton()
        
        
        if let plan = travelPlan {
                tripNameTextField.text = plan.planName
                locationName.text = plan.placeName
                dateLabel.text = plan.date
            if let tripMember = plan.tripMember, let numberOfPeople = Int(tripMember) {
                self.numberOfPeople = numberOfPeople
                peopleNumber.text = "\(numberOfPeople)"
            }
            createTripBtn.setTitle("Update Plan", for: .normal)
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
          view.addGestureRecognizer(tapGesture)
    }
    


    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView.frameLayoutGuide.snp.width)
        }
    }

    func addTapGestureToIcon(_ icon: UIImageView, action: Selector) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: action)
        icon.addGestureRecognizer(tapGestureRecognizer)
        icon.isUserInteractionEnabled = true
    }

    func addTabGuestureToView(_ view: UIView, action: Selector) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(tapGestureRecognizer)
        view.isUserInteractionEnabled = true
    }

    func addContentToScrollView() {
        // Add logo background
        let iconBackground = UIView()
        contentView.addSubview(iconBackground)
        iconBackground.backgroundColor = .white.withAlphaComponent(0.9)
        iconBackground.layer.cornerRadius = 50
        iconBackground.layer.shadowColor = UIColor.black.cgColor
        iconBackground.layer.shadowOpacity = 0.2
        iconBackground.layer.shadowOffset = CGSize(width: 0, height: 2)
        iconBackground.layer.shadowRadius = 4

        iconBackground.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(contentView.snp.top).offset(20)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }

        let logoImage = UIImageView()
        logoImage.image = UIImage(named: "AppIcon")
        iconBackground.addSubview(logoImage)
        logoImage.snp.makeConstraints { make in
            make.center.equalTo(iconBackground)
            make.height.width.equalTo(80)
        }

        let titleLabel = UILabel()
        titleLabel.text = "Let’s get started planning a new trip"
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(20)
            make.centerX.equalTo(contentView)
            make.width.equalTo(200)
        }

        let locationLabel = UILabel()
        contentView.addSubview(locationLabel)
        locationLabel.text = "Where to?"
        locationLabel.font = UIFont.boldSystemFont(ofSize: 17)
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.left.equalTo(contentView.snp.left).offset(20)
            make.right.equalTo(contentView.snp.right).offset(-20)
        }

        let whereToBtn = UIView()
        whereToBtn.layer.borderWidth = 1
        whereToBtn.layer.borderColor = UIColor.lightGray.cgColor
        whereToBtn.layer.cornerRadius = 5
        whereToBtn.isUserInteractionEnabled = true
        contentView.addSubview(whereToBtn)
        whereToBtn.backgroundColor = .white
        addTabGuestureToView(whereToBtn, action: #selector(selectTripTapped))

        whereToBtn.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(8)
            make.left.equalTo(contentView.snp.left).offset(20)
            make.right.equalTo(contentView.snp.right).offset(-20)
            make.height.equalTo(50)
        }

        let selectedIcon = UIImageView()
        whereToBtn.addSubview(selectedIcon)
        selectedIcon.image = UIImage(named: "Location")

        selectedIcon.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalTo(whereToBtn)
            make.left.equalTo(whereToBtn.snp.left).offset(8)
        }

        locationName.text = "Find your location"
        locationName.font = UIFont.boldSystemFont(ofSize: 15)
        whereToBtn.addSubview(locationName)

        locationName.snp.makeConstraints { make in
            make.centerY.equalTo(whereToBtn)
            make.left.equalTo(selectedIcon.snp.right).offset(10)
            make.right.equalTo(whereToBtn.snp.right).offset(-10)
        }

        // Trip Date Section
        let tripDateLabel = UILabel()
        contentView.addSubview(tripDateLabel)
        tripDateLabel.text = "Trip Date"
        tripDateLabel.font = UIFont.boldSystemFont(ofSize: 17)
        tripDateLabel.snp.makeConstraints { make in
            make.top.equalTo(whereToBtn.snp.bottom).offset(15)
            make.left.equalTo(contentView.snp.left).offset(20)
            make.right.equalTo(contentView.snp.right).offset(-20)
        }

        let tripView = UIView()
        tripView.layer.borderWidth = 1
        tripView.layer.borderColor = UIColor.lightGray.cgColor
        tripView.isUserInteractionEnabled = true
        tripView.layer.cornerRadius = 5
        addTabGuestureToView(tripView, action: #selector(tripViewTapped))
        
        contentView.addSubview(tripView)
        tripView.backgroundColor = .white
        tripView.snp.makeConstraints { make in
            make.top.equalTo(tripDateLabel.snp.bottom).offset(8)
            make.left.equalTo(contentView.snp.left).offset(20)
            make.right.equalTo(contentView.snp.right).offset(-20)
            make.height.equalTo(50)
        }

        let tripIcon = UIImageView()
        tripView.addSubview(tripIcon)
        tripIcon.image = UIImage(named: "Calendar1")
        tripIcon.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalTo(tripView)
            make.left.equalTo(tripView.snp.left).offset(8)
        }


        tripView.addSubview(dateLabel)
        dateLabel.text = "Plan date"
        dateLabel.font = UIFont.boldSystemFont(ofSize: 15)

        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(tripView)
            make.left.equalTo(tripIcon.snp.right).offset(10)
            make.right.equalTo(tripView.snp.right).offset(-10)
        }

        // Add Person Section
        let addPersonLabel = UILabel()
        contentView.addSubview(addPersonLabel)
        addPersonLabel.text = "Add Person"
        addPersonLabel.font = UIFont.boldSystemFont(ofSize: 17)
        addPersonLabel.snp.makeConstraints { make in
            make.top.equalTo(tripView.snp.bottom).offset(15)
            make.left.equalTo(contentView.snp.left).offset(20)
            make.right.equalTo(contentView.snp.right).offset(-20)
        }

        let addPersonView = UIView()
        addPersonView.layer.borderWidth = 1
        addPersonView.layer.borderColor = UIColor.lightGray.cgColor
        addPersonView.layer.cornerRadius = 5
        contentView.addSubview(addPersonView)
        addPersonView.backgroundColor = .white
        addPersonView.snp.makeConstraints { make in
            make.top.equalTo(addPersonLabel.snp.bottom).offset(8)
            make.left.equalTo(contentView.snp.left).offset(20)
            make.right.equalTo(contentView.snp.right).offset(-20)
            make.height.equalTo(50)
        }

        let subtractIcon = UIImageView()
        addPersonView.addSubview(subtractIcon)
        subtractIcon.image = UIImage(named: "minus")
        subtractIcon.isUserInteractionEnabled = true
        subtractIcon.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalTo(addPersonView)
            make.left.equalTo(addPersonView.snp.left).offset(8)
        }

        addPersonView.addSubview(peopleNumber)
        peopleNumber.text = "\(numberOfPeople)"
        peopleNumber.font = UIFont.boldSystemFont(ofSize: 17)
        peopleNumber.textAlignment = .center
        peopleNumber.snp.makeConstraints { make in
            make.centerY.equalTo(addPersonView)
            make.left.equalTo(subtractIcon.snp.right).offset(0)
            make.width.equalTo(50)
        }

        let addIcon = UIImageView()
        addPersonView.addSubview(addIcon)
        addIcon.image = UIImage(named: "addPerson")
        addIcon.isUserInteractionEnabled = true
        addIcon.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalTo(addPersonView)
            make.left.equalTo(peopleNumber.snp.right).offset(0)
        }

        // Use the helper function to add gesture recognizers
        addTapGestureToIcon(subtractIcon, action: #selector(decreasePersonCount))
        addTapGestureToIcon(addIcon, action: #selector(increasePersonCount))
        
        // add trip name
        let tripNameLabel = UILabel()
        contentView.addSubview(tripNameLabel)
        tripNameLabel.text = "Trip Name"
        tripNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        tripNameLabel.snp.makeConstraints { make in
            make.top.equalTo(addPersonView.snp.bottom).offset(15)
            make.left.equalTo(contentView.snp.left).offset(20)
            make.right.equalTo(contentView.snp.right).offset(-20)
        }
        
        contentView.addSubview(tripNameTextField)
        tripNameTextField.borderColor = .gray
        tripNameTextField.layer.borderWidth = 0.65
        tripNameTextField.placeholder = "give your trip name"
        tripNameTextField.snp.makeConstraints { make in
            make.top.equalTo(tripNameLabel.snp.bottom).offset(8)
            make.left.equalTo(contentView.snp.left).offset(20)
            make.right.equalTo(contentView.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        
       
        contentView.addSubview(createTripBtn)
        createTripBtn.backgroundColor = .black
        createTripBtn.setTitle("Let’s Start your Plan", for: .normal)
        createTripBtn.setTitleColor(.white, for: .normal)
        createTripBtn.addTarget(self, action: #selector(createTripbtnTapped), for: .touchUpInside)
        createTripBtn.layer.cornerRadius = 10
        createTripBtn.snp.makeConstraints { make in
            make.top.equalTo(tripNameTextField.snp.bottom).offset(20)
            make.left.equalTo(contentView.snp.left).offset(20)
            make.right.equalTo(contentView.snp.right).offset(-20)
            make.height.equalTo(50)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20) // This constraint sets the bottom of contentView to the bottom of the button
        }
    }
    
    @IBAction func createTripbtnTapped(){
        guard let planName = tripNameTextField.text, !planName.isEmpty,
           let placeName = locationName.text, placeName != "Find your location",
           let date = dateLabel.text, date != "Plan Date" else {
           showAlert(title: "Entry Error", message: "Please try again!")
            return
        }
        
        if let travelPlan = travelPlan {
            updatePlan(travelPlan)
        }else{
            if tripNameExist(withName: planName) {
                showAlert(title: "Error", message: "Folder with the same name already exists.")
            } else {
                savePlan(name: planName)
                showAlert(title: "Success", message: "Create folder successfully!"){ [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func updatePlan(_ plan: TravelPlan) {
            let context = CoreDataManager.shared.context
            plan.planName = tripNameTextField.text
            plan.placeName = locationName.text
            plan.date = dateLabel.text
            plan.tripMember = peopleNumber.text
            
            do {
                try context.save()
                showAlert(title: "Success", message: "Plan updated successfully!") { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            } catch {
                showAlert(title: "Error", message: "Failed to update plan.")
                print("Failed to update plan: \(error)")
            }
        }
 
    private func tripNameExist(withName name: String) -> Bool {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<TravelPlan> = TravelPlan.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "planName == %@", name)

        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Failed to fetch folder: \(error)")
            return false
        }
    }

    private func savePlan(name: String) {
        let context = CoreDataManager.shared.context
        let plan = TravelPlan(context: context)
        plan.planName = tripNameTextField.text
        plan.planID = UUID().uuidString // Setting a unique folder ID
        plan.placeName = locationName.text
        plan.date = dateLabel.text
        plan.tripMember = peopleNumber.text

        do {
            try context.save()
        } catch {
            showAlert(title: "Error", message: "Failed to save folder.")
            print("Failed to save folder: \(error)")
        }
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true, completion: nil)
    }
    
    @objc func decreasePersonCount() {
        print("Decrease tapped")
        if numberOfPeople > 1 {
            numberOfPeople -= 1
            peopleNumber.text = "\(numberOfPeople)"
        }
    }

    @objc func increasePersonCount() {
        print("Increase tapped")
        numberOfPeople += 1
        peopleNumber.text = "\(numberOfPeople)"
    }
    
    @objc func tripViewTapped() {
        print("Select Date")
        let viewController = AddDateViewController()
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = halfPresentaion
        viewController.delegate = self  // Set the delegate here
        present(viewController, animated: true)
    }
    
    @objc func selectTripTapped() {
        print("Select Place")
        let viewController = AddPlaceViewController()
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = halfPresentaion
        viewController.delegate = self  // Set the delegate here
        present(viewController, animated: true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height

            // Adjust the content inset of the scroll view
            scrollView.contentInset.bottom = keyboardHeight

            // Scroll to the bottom of the scroll view
            let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom)
            scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }


    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset.bottom = 0
            self.createTripBtn.snp.updateConstraints { make in
                make.bottom.equalTo(self.contentView.snp.bottom).offset(-20)
            }
            self.view.layoutIfNeeded()
        }
    }

    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - AddPlaceDelegate
    func didSelectPlace(_ place: String) {
        locationName.text = place
    }
    func didSelectDate(_ date: String) {
        dateLabel.text = date
    }
    
    
    
}

