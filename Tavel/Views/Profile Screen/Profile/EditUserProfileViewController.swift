//
//  EditUserProfileViewController.swift
//  Tavel
//
//  Created by user245540 on 8/17/24.
//
import UIKit
import SnapKit

class EditUserProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    let scrollView = UIScrollView()
    let contentView = UIView()
    let titleLabel = UILabel()
    let backView = UIView()
    let profileImage = UIImageView()
    let usernameTextField = TextFieldWithPadding()
    let dobTextField = TextFieldWithPadding() // Date of Birth TextField
    let genderTextField = TextFieldWithPadding() // Gender TextField
    let datePicker = UIDatePicker()
    let genderPicker = UIPickerView()
    let genderOptions = ["Male", "Female", "Other"]
    let phoneNumberTextField = TextFieldWithPadding()
    let updateButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let viewTappedGuesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(viewTappedGuesture)

        setupUI()
        showDatePicker()
        showGenderPicker()
        setupConstraint()
        setupCustomBackButton()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
        
        // Remove 'Back' text and Title from Navigation Bar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = ""
    }
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupCustomBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "custom_back_icon"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }
    @objc func viewTapped(){
        view.endEditing(true)
    }
    func setupUI() {
        // Add all subviews and set up constraints using SnapKit or Auto Layout
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(backView)
        backView.backgroundColor = .blue.withAlphaComponent(0.6)
        backView.layer.cornerRadius = 45
        backView.addSubview(profileImage)
        profileImage.image = UIImage(named: "profile11")
        profileImage.isUserInteractionEnabled = true
        profileImage.layer.cornerRadius = 40
        profileImage.clipsToBounds = true
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(tappedProfile))
        profileImage.addGestureRecognizer(tapGuesture)
        
        contentView.addSubview(usernameTextField)
        usernameTextField.setupLeftIcon(UIImage(named: "Profile_selected"))
        usernameTextField.placeholder = "Enter your name"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.borderColor = .black.withAlphaComponent(0.3)
        
        contentView.addSubview(dobTextField)
        dobTextField.placeholder = "Select Birthday"
        dobTextField.borderColor = .black.withAlphaComponent(0.3)
        dobTextField.borderStyle = .roundedRect
        dobTextField.setupLeftIcon(UIImage(named: "dob"))
        
        
        contentView.addSubview(genderTextField)
        genderTextField.placeholder = "Select Gender"
        genderTextField.borderColor = .black.withAlphaComponent(0.3)
        genderTextField.setupLeftIcon(UIImage(named: "email"))
        genderTextField.borderStyle = .roundedRect
        
        contentView.addSubview(phoneNumberTextField)
        phoneNumberTextField.placeholder = "Enter your phone"

        phoneNumberTextField.borderColor = .black.withAlphaComponent(0.3)
        phoneNumberTextField.setupLeftIcon(UIImage(named: "Call"))
        phoneNumberTextField.borderStyle = .roundedRect
        

        // Example of setting up the titleLabel
        titleLabel.text = "Update Your Profile"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        
        // set up button
        contentView.addSubview(updateButton)
        updateButton.setTitle("Update", for: .normal)
        updateButton.setTitleColor(.white, for: .normal)
        updateButton.backgroundColor = .black
        updateButton.layer.cornerRadius = 10
        updateButton.addTarget(self, action: #selector(updateTapped), for: .touchUpInside)
    }
    @objc func updateTapped(){
        print("Update Tapped")
    }
    @objc func tappedProfile(){
        print("Image Tapped")
        let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
    
            present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            profileImage.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImage.image = originalImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func setupConstraint() {
        // Set up scrollView constraints
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        // Set up contentView constraints
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide.snp.width)
        }

        // Set up backView constraints
        backView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(50)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.height.equalTo(90)
        }

        // Set up profileImage constraints
        profileImage.snp.makeConstraints { make in
            make.center.equalTo(backView)
            make.width.height.equalTo(80)
        }

        // Set up titleLabel constraints
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.bottom).offset(15)
            make.left.equalTo(contentView.snp.left).offset(20)
            make.right.equalTo(contentView.snp.right).offset(-20)
        }

        // Set up usernameTextField constraints
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.right.equalTo(titleLabel)
            make.height.equalTo(50)
        }

        // Set up dobTextField constraints
        dobTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(10)
            make.left.right.height.equalTo(usernameTextField)
        }

        // Set up genderTextField constraints
        genderTextField.snp.makeConstraints { make in
            make.top.equalTo(dobTextField.snp.bottom).offset(10)
            make.left.right.height.equalTo(dobTextField)
        }

        // Set up phoneNumberTextField constraints
        phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(genderTextField.snp.bottom).offset(10)
            make.left.right.height.equalTo(genderTextField)
        }

        // Set up updateButton constraints
        updateButton.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(30)
            make.left.right.equalTo(phoneNumberTextField)
            make.height.equalTo(50)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
    }



    func showDatePicker() {
        // Configure date picker
        datePicker.datePickerMode = .date
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        // Configure toolbar with Done and Cancel buttons
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        
        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)
        
        // Set input views for dobTextField
        dobTextField.inputAccessoryView = toolbar
        dobTextField.inputView = datePicker
    }

    @objc func donedatePicker() {
        // Format selected date and set it to dobTextField
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dobTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }

    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }

    func showGenderPicker() {
        // Set the UIPickerView's dataSource and delegate
        genderPicker.delegate = self
        genderPicker.dataSource = self
        
        // Configure toolbar with Done and Cancel buttons
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneGenderPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelGenderPicker))
        
        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)
        
        // Set input views for genderTextField
        genderTextField.inputAccessoryView = toolbar
        genderTextField.inputView = genderPicker
    }

    @objc func doneGenderPicker() {
        let selectedRow = genderPicker.selectedRow(inComponent: 0)
        genderTextField.text = genderOptions[selectedRow]
        self.view.endEditing(true)
    }

    @objc func cancelGenderPicker() {
        self.view.endEditing(true)
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension EditUserProfileViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderOptions[row]
    }
}
