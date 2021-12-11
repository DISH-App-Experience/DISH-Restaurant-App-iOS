//
//  SignUpInformationController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/6/21.
//

import UIKit
import Firebase
import MBProgressHUD
import UserNotifications

class SignUpInformationController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var email : String?
    
    var birthdayString : String?
    
    var birthdayDate = Date()
    
    let birthdayPicker = UIDatePicker()
    
    let genderPicker = UIPickerView()
    
    let genders = ["Male", "Female", "Other"]
    
    let firstNameTextField : MainTextField = {
        let textField = MainTextField(placeholderString: "First Name")
        textField.keyboardType = UIKeyboardType.default
        return textField
    }()
    
    let lastNameTextField : MainTextField = {
        let textField = MainTextField(placeholderString: "Last Name")
        textField.keyboardType = UIKeyboardType.default
        return textField
    }()
    
    let genderTextField : MainTextField = {
        let textField = MainTextField(placeholderString: "Gender")
        textField.keyboardType = UIKeyboardType.default
        return textField
    }()
    
    let birthdayTextField : MainTextField = {
        let textField = MainTextField(placeholderString: "Birthday")
        textField.keyboardType = UIKeyboardType.default
        return textField
    }()
    
    let mainButton : MainButton = {
        let button = MainButton()
        button.backgroundColor = Restaurant.shared.themeColor
        button.addTarget(self, action: #selector(mainButtonPressed), for: UIControl.Event.touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Restaurant.shared.backgroundColor
        
        updateViewConstraints()
        setupButtons()
        pickerViewSetup()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Your Information"
        navigationController?.navigationBar.isHidden = false
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        view.addSubview(firstNameTextField)
        firstNameTextField.delegate = self
        firstNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 61).isActive = true
        firstNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        firstNameTextField.widthAnchor.constraint(equalToConstant: 178).isActive = true
        firstNameTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(lastNameTextField)
        lastNameTextField.delegate = self
        lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.topAnchor).isActive = true
        lastNameTextField.leftAnchor.constraint(equalTo: firstNameTextField.rightAnchor, constant: 15).isActive = true
        lastNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        lastNameTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(genderTextField)
        genderTextField.delegate = self
        genderTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 15).isActive = true
        genderTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        genderTextField.widthAnchor.constraint(equalToConstant: 155).isActive = true
        genderTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(birthdayTextField)
        birthdayTextField.delegate = self
        birthdayTextField.topAnchor.constraint(equalTo: genderTextField.topAnchor).isActive = true
        birthdayTextField.leftAnchor.constraint(equalTo: genderTextField.rightAnchor, constant: 15).isActive = true
        birthdayTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        birthdayTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(mainButton)
        mainButton.topAnchor.constraint(equalTo: birthdayTextField.bottomAnchor, constant: 29).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    private func setupButtons() {
        mainButton.setAttributedTitle(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.foregroundColor : Restaurant.shared.textColorOnButton, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]), for: UIControl.State.normal)
    }
    
    private func completion() {
        birthdayNotification(withDate: birthdayDate)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.hideLoading()
            self.moveToTabbar()
        })
    }
    
    private func birthdayNotification(withDate date: Date) {

        let notificationCenter = UNUserNotificationCenter.current()
        
        let notification = UNMutableNotificationContent()
        notification.title = "Important Message"
        notification.body = "It's a snow day tomorrow. No school busses."
        notification.categoryIdentifier = "alarm"
        notification.userInfo = ["additionalData": "Additional data can also be provided"]
        notification.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 0
    }
    
    private func pickerViewSetup() {
        genderTextField.inputView = genderPicker
        genderPicker.delegate = self
        genderPicker.dataSource = self
        
        birthdayTextField.setInputViewDatePicker(target: self, selector: #selector(donePressed))
    }
    
    @objc func donePressed() {
        if let datePicker = self.birthdayTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            let formatter = ISO8601DateFormatter()
            dateFormatter.dateStyle = .medium
            birthdayTextField.text = dateFormatter.string(from: datePicker.date)
            birthdayTextField.text = dateFormatter.string(from: datePicker.date)
            birthdayString = formatter.string(from: datePicker.date)
            birthdayDate = datePicker.date
        }
        birthdayTextField.resignFirstResponder()
    }
    
    @objc func mainButtonPressed() {
        showLoading()
        if let first = firstNameTextField.text, let last = lastNameTextField.text, let gender = genderTextField.text, let uid = Auth.auth().currentUser?.uid {
            let params : Dictionary<String, Any> = [
                "email" : String(email!),
                "gender" : gender,
                "firstName" : first,
                "lastName" : last,
                "birthday" : birthdayString ?? ISO8601DateFormatter().string(from: Date()),
                "uid" : uid
            ]
            Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(uid).updateChildValues(params)
            completion()
        } else {
            hideLoading()
            simpleAlert(title: "Error", message: "Please fill in all text fields.")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextField:
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            genderTextField.becomeFirstResponder()
        case genderTextField:
            birthdayTextField.becomeFirstResponder()
        case birthdayTextField:
            birthdayTextField.resignFirstResponder()
            mainButtonPressed()
        default:
            textField.resignFirstResponder()
        }
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = genders[row]
    }

}
