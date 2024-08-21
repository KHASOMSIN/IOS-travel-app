import UIKit

class AddReviewViewController: UIViewController, UITextViewDelegate {
    private let reviewLabel = UILabel()
    private let reviewDetailLabel = UILabel()
    private let starRatingView = UIStackView()
    private let textView = UITextView()
    private let characterCountLabel = UILabel()
    private let maxCharacters = 5000
    private let submitbtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        // Add specific corners (top left and top right)
        let path = UIBezierPath(roundedRect: view.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 16, height: 16))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask

        setupView()
     }


    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update the mask path in case the view's bounds change
        let path = UIBezierPath(roundedRect: view.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 16, height: 16))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }
    
    func setupView() {
        reviewLabel.text = "Write Review"
        reviewLabel.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(reviewLabel)
        
        reviewDetailLabel.text = "Review Detail"
        reviewDetailLabel.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(reviewDetailLabel)
        
        submitbtn.setTitle("Submit", for: .normal)
        submitbtn.setTitleColor(.white, for: .normal)
        submitbtn.backgroundColor = .black
        submitbtn.layer.cornerRadius = 10
        view.addSubview(submitbtn)

        // Configure the star rating view
        starRatingView.axis = .horizontal
        starRatingView.distribution = .fillEqually
        starRatingView.spacing = 8
        view.addSubview(starRatingView)
        
        for _ in 1...5 {
            let starButton = UIButton()
            if #available(iOS 13.0, *) {
                starButton.setImage(UIImage(systemName: "star"), for: .normal)
                starButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
            } else {
                starButton.setImage(UIImage(named: "star"), for: .normal)
                starButton.setImage(UIImage(named: "star.fill"), for: .selected)
            }
            starButton.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
            starRatingView.addArrangedSubview(starButton)
        }
        
        // Configure the text view
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 8
        view.addSubview(textView)
        
        // Configure the character count label
        characterCountLabel.text = "0/\(maxCharacters)"
        characterCountLabel.textAlignment = .right
        characterCountLabel.font = UIFont.systemFont(ofSize: 12)
        view.addSubview(characterCountLabel)
        
        // Layout constraints
        starRatingView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        characterCountLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewLabel.translatesAutoresizingMaskIntoConstraints = false
        reviewDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        submitbtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            reviewLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            reviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            reviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            starRatingView.topAnchor.constraint(equalTo: reviewLabel.bottomAnchor, constant: 15),
            starRatingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            starRatingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            reviewDetailLabel.topAnchor.constraint(equalTo: starRatingView.bottomAnchor, constant: 15),
            reviewDetailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            reviewDetailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            textView.topAnchor.constraint(equalTo: reviewDetailLabel.bottomAnchor, constant: 15),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.heightAnchor.constraint(equalToConstant: 160),
            
            characterCountLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8),
            characterCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            characterCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            submitbtn.heightAnchor.constraint(equalToConstant: 50),
            submitbtn.topAnchor.constraint(equalTo: characterCountLabel.bottomAnchor, constant: 15),
            submitbtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            submitbtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func starTapped(_ sender: UIButton) {
        guard let index = starRatingView.arrangedSubviews.firstIndex(of: sender) else { return }
        
        for (i, view) in starRatingView.arrangedSubviews.enumerated() {
            guard let button = view as? UIButton else { continue }
            button.isSelected = i <= index
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let characterCount = textView.text.count
        if characterCount > maxCharacters {
            textView.text = String(textView.text.prefix(maxCharacters))
        }
        characterCountLabel.text = "\(textView.text.count)/\(maxCharacters)"
    }
}
