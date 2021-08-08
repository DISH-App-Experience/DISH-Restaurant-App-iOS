//
//  ProfileInformationController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/8/21.
//

import UIKit
import Firebase

class ProfileInformationController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var birthdayInt = Int()
    
    var birthdayDate = Date()
    
    var id : String? {
        didSet {
            backend()
        }
    }
    
    var navTitle : String? {
        didSet {
            navigationItem.title = navTitle!
        }
    }
    
    let birthdayPicker = UIDatePicker()
    
    let genderPicker = UIPickerView()
    
    let genders = ["Male", "Female", "Other"]
    
    let emailTextfield : MainTextField = {
        let textField = MainTextField(placeholderString: "Write Here")
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.backgroundColor = Restaurant.shared.secondaryBackground
        return textField
    }()
    
    let mainButton : MainButton = {
        let button = MainButton()
        button.backgroundColor = Restaurant.shared.themeColor
        button.setTitleColor(Restaurant.shared.textColorOnButton, for: UIControl.State.normal)
        button.setTitle("Save", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(mainButtonPressed), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Restaurant.shared.backgroundColor
        
        updateViewConstraints()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        view.addSubview(emailTextfield)
        emailTextfield.delegate = self
        emailTextfield.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 41).isActive = true
        emailTextfield.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        emailTextfield.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        emailTextfield.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(mainButton)
        mainButton.topAnchor.constraint(equalTo: emailTextfield.bottomAnchor, constant: 29).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        mainButtonPressed()
        return (true)
    }
    
    func backend() {
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(Auth.auth().currentUser!.uid).child(id!).observe(DataEventType.value) { snapshot in
            if self.id == "birthday" {
                if let value = snapshot.value as? Int {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MMM d, yyyy"
                    self.emailTextfield.text = "\(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(value))))"
                    self.dateTFP()
                }
            } else if self.id == "gender" {
                if let value = snapshot.value as? String {
                    self.emailTextfield.text = value
                    self.genderTFP()
                }
            } else {
                if let value = snapshot.value as? String {
                    self.emailTextfield.text = value
                }
            }
        }
    }
    
    @objc func mainButtonPressed() {
        showLoading()
        if self.id == "birthday" {
            Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(Auth.auth().currentUser!.uid).child(self.id!).setValue(birthdayInt) { error, reference in
                if error == nil {
                    self.hideLoading()
                    self.simpleAlert(title: "Success", message: "Your information has been saved")
                }
            }
        } else {
            Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(Auth.auth().currentUser!.uid).child(self.id!).setValue(self.emailTextfield.text!) { error, reference in
                if error == nil {
                    self.hideLoading()
                    self.simpleAlert(title: "Success", message: "Your information has been saved")
                }
            }
        }
    }
    
    private func dateTFP() {
        birthdayPicker.datePickerMode = UIDatePicker.Mode.date
        birthdayPicker.frame.size = CGSize(width: 0, height: 250)
        birthdayPicker.addTarget(self, action: #selector(birthdayPickerChanged), for: UIControl.Event.valueChanged)
        emailTextfield.inputView = birthdayPicker
    }
    
    private func genderTFP() {
        emailTextfield.inputView = genderPicker
        genderPicker.delegate = self
        genderPicker.dataSource = self
    }
    
    @objc func birthdayPickerChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        emailTextfield.text = dateFormatter.string(from: datePicker.date)
        birthdayInt = Int(datePicker.date.timeIntervalSince1970)
        birthdayDate = datePicker.date
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
        emailTextfield.text = genders[row]
    }

}
