import UIKit
import SnapKit
import CoreData
class AddTripViewController: UIViewController {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let titleLabel = UILabel()
    let planTripImage = UIImageView()
    let detailTripImage = UIImageView()
    let listTripImage = UIImageView()
    let menuView = UIView()
    var plantripLabel: UILabel!
    var detailtripLabel: UILabel!
    var listItemLabel: UILabel!
    let menuView1 = UIView()
    let menuView2 = UIView()
    let menuView3 = UIView()
    var showPlanCollectionView: UICollectionView!
    let planLayoutView = UICollectionViewFlowLayout()
    
    var fetchResultsController: NSFetchedResultsController<TravelPlan>?
    
    let plan:TravelPlan? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Start Your Plan"
        view.backgroundColor = UIColor(hex: "F3F2EC")
        createView()
        setConstraints()
        addTapGestureRecognizers()
        
        showPlanCollectionView.dataSource = self
        showPlanCollectionView.delegate = self
        setupFetchedResultsController()
        fetchPlans()
    }
    
    // Create and configure NSFetchedResultsController
        private func setupFetchedResultsController() {
            let fetchRequest: NSFetchRequest<TravelPlan> = TravelPlan.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)] // Adjust as per your model
            
            fetchResultsController = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: CoreDataManager.shared.context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            fetchResultsController?.delegate = self
        }
        
        private func fetchPlans() {
            do {
                try fetchResultsController?.performFetch()
                showPlanCollectionView.reloadData()
            } catch {
                print("Failed to fetch plans: \(error)")
            }
        }
    
    private func createView() {
        // Add ScrollView
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Menu background
        contentView.addSubview(menuView)
        menuView.backgroundColor = .white
        menuView.layer.cornerRadius = 10
        menuView.addShadow(color: .black, opacity: 0.1)
        
        // Setup menu images and labels
        setMenuImage(planTripImage, named: "create plan")
        setMenuImage(detailTripImage, named: "detailtrip")
        setMenuImage(listTripImage, named: "itemlist")
        
        plantripLabel = UILabel()
        setupMenuLabel(plantripLabel, text: "Create Plan")
        
        detailtripLabel = UILabel()
        setupMenuLabel(detailtripLabel, text: "Detail Trip")
        
        listItemLabel = UILabel()
        setupMenuLabel(listItemLabel, text: "Item Trip")
        
        planLayoutView.minimumLineSpacing = 10
        planLayoutView.scrollDirection = .vertical
        showPlanCollectionView = UICollectionView(frame: .zero, collectionViewLayout: planLayoutView)
        showPlanCollectionView.register(PlanCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        contentView.addSubview(showPlanCollectionView)
        showPlanCollectionView.layer.cornerRadius = 10
      
        showPlanCollectionView.snp.makeConstraints { make in
            make.top.equalTo(menuView.snp.bottom).offset(5)
            make.left.equalTo(contentView.snp.left).offset(0)
            make.right.equalTo(contentView.snp.right).offset(0)
            make.bottom.equalTo(contentView.snp.bottom).offset(0)
        }
    }
    
    func setupMenuLabel(_ label: UILabel, text: String) {
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.text = text
        menuView.addSubview(label)
    }
    
    func setMenuImage(_ menu: UIImageView, named imageName: String) {
        menu.image = UIImage(named: imageName)
        menu.isUserInteractionEnabled = true // Enable user interaction for tap gestures
        menuView.addSubview(menu)
    }

    private func addTapGestureRecognizers() {
        // Add tap gesture recognizers to each image view
        let planTapGesture = UITapGestureRecognizer(target: self, action: #selector(planTripImageTapped))
        menuView1.addGestureRecognizer(planTapGesture)
        
        let detailTapGesture = UITapGestureRecognizer(target: self, action: #selector(detailTripImageTapped))
        menuView2.addGestureRecognizer(detailTapGesture)
        
        let listTapGesture = UITapGestureRecognizer(target: self, action: #selector(listTripImageTapped))
        menuView3.addGestureRecognizer(listTapGesture)
    }
    
    @objc private func planTripImageTapped() {
        print("Plan Trip Image Tapped")
        let viewController = CreatePlanViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func detailTripImageTapped() {
        print("Detail Trip Image Tapped")
        // Handle the tap event for the detailTripImage
    }
    
    @objc private func listTripImageTapped() {
        print("List Trip Image Tapped")
        // Handle the tap event for the listTripImage
    }
}

extension AddTripViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let sections = fetchResultsController?.sections?.count ?? 0
        print("Number of sections: \(sections)")
        return sections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items = fetchResultsController?.sections?[section].numberOfObjects ?? 0
        print("Number of items in section \(section): \(items)")
        return items
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PlanCollectionViewCell
        
        // Retrieve the plan object from the fetched results controller
        if let plan = fetchResultsController?.object(at: indexPath) {
            print("Configuring cell with plan: \(plan.planName ?? "")")
            cell.configure(with: plan)
            
            // Ensure the plan object is passed correctly to the edit action
            cell.editAction = { [weak self] in
                guard let self = self else { return }
                let editVC = CreatePlanViewController()
                editVC.travelPlan = plan // Pass the selected plan to the edit VC
                self.navigationController?.pushViewController(editVC, animated: true)
            }
            
            cell.deleteAction = {[weak self] in
                guard let self = self else { return }
                
                // Confirm deletion
                let alert = UIAlertController(title: "Delete Plan", message: "Are you sure you want to delete this plan?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                    // Perform the deletion
                    self.deletePlan(plan)
                }))
                
                // Present the confirmation alert
                self.present(alert, animated: true, completion: nil)
            }
        }
        return cell
    }
    
    private func deletePlan(_ plan: TravelPlan) {
        let context = CoreDataManager.shared.context
        
        // Fetch associated PlanDetail objects
        let fetchRequest: NSFetchRequest<PlanDetails> = PlanDetails.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "travelPlan == %@", plan)
        
        do {
            let details = try context.fetch(fetchRequest)
            
            // Delete associated PlanDetail objects
            for detail in details {
                context.delete(detail)
            }
            
            // Delete the TravelPlan object
            context.delete(plan)
            
            // Save the context to persist changes
            try context.save()
        } catch {
            print("Failed to delete plan or its details: \(error)")
            // Optionally, present an alert to the user indicating the failure
        }
    }



}

extension AddTripViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let plan = fetchResultsController?.object(at: indexPath) else {
            return
        }
                // Instantiate PlanDetailViewController correctly
        let viewController = PlanDetailViewController()
                
                // Pass the selected plan to the view controller
            viewController.travelPlan = plan
                // Push the view controller onto the navigation stack
                navigationController?.pushViewController(viewController, animated: true)
            }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.frame.width // Adjust as needed
            return CGSize(width: width, height: 130) // Set height based on your design
        }
}

extension AddTripViewController {
    func setConstraints() {
        // Set up scroll view constraints
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        // Set up content view constraints
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
            make.height.equalTo(scrollView.snp.height).priority(.low)
            // Match the width of the scroll view
        }
        
        menuView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(0)
            make.left.equalTo(contentView.snp.left).offset(0)
            make.right.equalTo(contentView.snp.right).offset(0)
            make.height.equalTo(120)
        }
        
        // Create menu views
        setupMenu(menuView1)
        setupMenu(menuView2)
        setupMenu(menuView3)
        
        menuView1.isUserInteractionEnabled = true
        menuView2.isUserInteractionEnabled = true
        menuView3.isUserInteractionEnabled = true
        
        // Add images and labels to menu views
        menuView1.addSubview(planTripImage)
        menuView1.addSubview(plantripLabel)
        
        menuView2.addSubview(detailTripImage)
        menuView2.addSubview(detailtripLabel)
        
        menuView3.addSubview(listTripImage)
        menuView3.addSubview(listItemLabel)
        
        // Set constraints for menu views
        menuView1.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(90)
            make.centerY.equalTo(menuView)
            make.right.equalTo(menuView2.snp.left).offset(-8)
        }
        menuView2.snp.makeConstraints { make in
            make.centerX.equalTo(menuView)
            make.centerY.equalTo(menuView)
            make.height.equalTo(100)
            make.width.equalTo(90)
        }
        menuView3.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(90)
            make.centerY.equalTo(menuView)
            make.left.equalTo(menuView2.snp.right).offset(8)
        }
        
        // Set constraints for images
        planTripImage.snp.makeConstraints { make in
            make.top.equalTo(menuView1.snp.top).offset(5)
            make.centerX.equalTo(menuView1.snp.centerX).offset(0)
            make.height.equalTo(60)
            make.width.equalTo(60)
        }
        detailTripImage.snp.makeConstraints { make in
            make.top.equalTo(menuView2.snp.top).offset(5)
            make.centerX.equalTo(menuView2.snp.centerX).offset(0)
            make.height.equalTo(60)
            make.width.equalTo(60)
        }
        listTripImage.snp.makeConstraints { make in
            make.top.equalTo(menuView3.snp.top).offset(5)
            make.centerX.equalTo(menuView3.snp.centerX).offset(0)
            make.height.equalTo(60)
            make.width.equalTo(60)
        }
        
        // Set constraints for labels
        plantripLabel.snp.makeConstraints { make in
            make.top.equalTo(planTripImage.snp.bottom).offset(10)
            make.left.equalTo(menuView1.snp.left).offset(0)
            make.right.equalTo(menuView1.snp.right).offset(0)
            make.bottom.equalTo(menuView1.snp.bottom).offset(-10)
        }
        detailtripLabel.snp.makeConstraints { make in
            make.top.equalTo(detailTripImage.snp.bottom).offset(10)
            make.left.equalTo(menuView2.snp.left).offset(0)
            make.right.equalTo(menuView2.snp.right).offset(0)
            make.bottom.equalTo(menuView2.snp.bottom).offset(-10)
        }
        listItemLabel.snp.makeConstraints { make in
            make.top.equalTo(listTripImage.snp.bottom).offset(10)
            make.left.equalTo(menuView3.snp.left).offset(0)
            make.right.equalTo(menuView3.snp.right).offset(0)
            make.bottom.equalTo(menuView3.snp.bottom).offset(-10)
        }
        
    }
    
    func setupMenu(_ menu: UIView) {
        menuView.addSubview(menu)
        menu.addShadow(opacity: 0.3)
        menu.backgroundColor = .white
        menu.layer.cornerRadius = 5
    }
}

extension AddTripViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        showPlanCollectionView.reloadData()
    }
}
