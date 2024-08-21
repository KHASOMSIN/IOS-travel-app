import UIKit
import FSCalendar

protocol AddDateDelegate: AnyObject {
    func didSelectDate(_ date: String)
}

class AddDateViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {

    weak var delegate: AddDateDelegate?

    private let calendar = FSCalendar()
    private var selectedDates = Set<Date>()
    private var startDate: Date?
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true

        setupViewBackground()
        view.addSubview(calendar)
        view.addSubview(confirmButton)
        
        setupCalendar()
        setupConfirmButton()
        addSwipeGesture()
     }
 
    private func setupCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.allowsMultipleSelection = true
        
        // Customize appearance
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.weekdayTextColor = .blue
        calendar.appearance.todayColor = .red
        calendar.appearance.selectionColor = .green
        calendar.appearance.titleDefaultColor = .black
        calendar.appearance.titleSelectionColor = .white
        calendar.appearance.subtitleDefaultColor = .gray
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 18)
        calendar.appearance.weekdayFont = UIFont.systemFont(ofSize: 14)
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 16)
        calendar.appearance.subtitleFont = UIFont.systemFont(ofSize: 12)
        
        // Set layout
        calendar.scrollDirection = .horizontal
        calendar.scope = .month
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
            make.bottom.equalTo(confirmButton.snp.top).offset(-20)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViewBackground()
    }
    
    func setupViewBackground(){
        // Update the mask path in case the view's bounds change
        let path = UIBezierPath(roundedRect: view.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 16, height: 16))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }
    
    private func setupConfirmButton() {
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.height.equalTo(50)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
        }
    }

    private func formatDateRange() -> String {
        guard let minDate = selectedDates.min(), let maxDate = selectedDates.max() else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy"
        
        let startDateString = dateFormatter.string(from: minDate)
        let endDateString = dateFormatter.string(from: maxDate)
        
        return "\(startDateString) to \(endDateString)"
    }
    
    @objc private func confirmButtonTapped() {
        let formattedDateRange = formatDateRange()
        
        // Call the closure to send data back to the previous view controller
//        onDateRangeSelected?(formattedDateRange)
        delegate?.didSelectDate(formattedDateRange)
        dismiss(animated: true, completion: nil)
        // Dismiss the current view controller
//        dismiss(animated: true, completion: nil)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDates.insert(date)
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDates.remove(date)
    }
    
    private func addSwipeGesture() {
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        calendar.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func handleSwipe(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: calendar)
        
        switch gesture.state {
        case .began:
            if let date = dateForLocation(location) {
                self.startDate = date
                calendar.select(date)
                selectedDates.insert(date)
            }
        case .changed:
            if let endDate = dateForLocation(location), let startDate = self.startDate {
                let dates = datesBetween(startDate: startDate, endDate: endDate)
                selectedDates.formUnion(dates)
                calendar.select(dates)
            }
        case .ended:
            self.startDate = nil
        default:
            break
        }
    }
    
    private func dateForLocation(_ location: CGPoint) -> Date? {
        let point = calendar.convert(location, from: calendar.superview)
        for cell in calendar.collectionView.visibleCells {
            if let cell = cell as? FSCalendarCell, cell.frame.contains(point), let date = calendar.date(for: cell) {
                return date
            }
        }
        return nil
    }
    
    private func datesBetween(startDate: Date, endDate: Date) -> Set<Date> {
        var dates = Set<Date>()
        var currentDate = startDate
        
        while currentDate <= endDate {
            dates.insert(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dates
    }
    
    // FSCalendarDataSource method
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        if selectedDates.contains(date) {
            return "Selected"
        }
        return nil
    }
}
