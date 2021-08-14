//
//  CreateReservationController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 7/28/21.
//

import UIKit
import Firebase

class CreateReservationController: UIViewController, UITextFieldDelegate {
    
    let dateTF : MainTextField = {
        let textField = MainTextField(placeholderString: "Day of Reservation")
        textField.keyboardType = UIKeyboardType.default
        return textField
    }()
    
    let startTimeTF : MainTextField = {
        let textField = MainTextField(placeholderString: "Start Time")
        textField.keyboardType = UIKeyboardType.default
        return textField
    }()
    
    let endTimeTF : MainTextField = {
        let textField = MainTextField(placeholderString: "End Time")
        textField.keyboardType = UIKeyboardType.default
        return textField
    }()
    
    let numberOfGuestsTF : MainTextField = {
        let textField = MainTextField(placeholderString: "Number of Guests")
        textField.keyboardType = UIKeyboardType.numberPad
        return textField
    }()
    
    let mainButton : MainButton = {
        let button = MainButton()
        button.backgroundColor = Restaurant.shared.themeColor
        button.addTarget(self, action: #selector(mainButtonPressed), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    var date = Date()
    
    var startTime = Date()
    
    var endTime = Date()
    
    var lastName = ""
    
    var clear1 = false
    
    var clear2 = false
    
    var clear3 = false
    
    var clear4 = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Restaurant.shared.backgroundColor
        
        updateViewConstraints()
        
        getLastName()
        
        let startTimePicker = UIDatePicker()
        startTimePicker.datePickerMode = UIDatePicker.Mode.time
        startTimePicker.frame.size = CGSize(width: 0, height: 250)
        startTimePicker.addTarget(self, action: #selector(startTimePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        startTimeTF.inputView = startTimePicker
        
        let endTimePicker = UIDatePicker()
        endTimePicker.datePickerMode = UIDatePicker.Mode.time
        endTimePicker.frame.size = CGSize(width: 0, height: 250)
        endTimePicker.addTarget(self, action: #selector(endTimePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        endTimeTF.inputView = endTimePicker
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.frame.size = CGSize(width: 0, height: 250)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        dateTF.inputView = datePicker

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = Restaurant.shared.themeColor
        
        navigationItem.title = "Request Reservation"
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        view.addSubview(dateTF)
        dateTF.delegate = self
        dateTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        dateTF.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        dateTF.widthAnchor.constraint(equalToConstant: (view.frame.size.width / 2) - 30).isActive = true
        dateTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(numberOfGuestsTF)
        numberOfGuestsTF.delegate = self
        numberOfGuestsTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        numberOfGuestsTF.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        numberOfGuestsTF.widthAnchor.constraint(equalToConstant: (view.frame.size.width / 2) - 30).isActive = true
        numberOfGuestsTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(startTimeTF)
        startTimeTF.delegate = self
        startTimeTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        startTimeTF.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        startTimeTF.widthAnchor.constraint(equalToConstant: (view.frame.size.width / 2) - 30).isActive = true
        startTimeTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(endTimeTF)
        endTimeTF.delegate = self
        endTimeTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        endTimeTF.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        endTimeTF.widthAnchor.constraint(equalToConstant: (view.frame.size.width / 2) - 30).isActive = true
        endTimeTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(mainButton)
        mainButton.setAttributedTitle(NSAttributedString(string: "Request Reservation", attributes: [NSAttributedString.Key.foregroundColor : Restaurant.shared.textColorOnButton, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]), for: UIControl.State.normal)
        mainButton.topAnchor.constraint(equalTo: endTimeTF.bottomAnchor, constant: 16).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        clear2 = true
    }
    
    @objc func mainButtonPressed() {
        if clear1, clear2, clear3, clear4 {
            showLoading()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            let start = combineDateWithTime(date: date, time: startTime)
            let end = combineDateWithTime(date: date, time: endTime)
            
            let key = Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("reservations").childByAutoId().key
            let params : Dictionary<String, Any> = [
                "startTime" : formatter.string(from: start!),
                "endTime" : formatter.string(from: end!),
                "key" : key!,
                "numberOfSeats" : Int(numberOfGuestsTF.text!)!,
                "recipient" : Auth.auth().currentUser!.uid,
                "status" : "pending",
                "timeRequestSubmitted" : Int(Date().timeIntervalSince1970),
                "userId" : lastName
            ]
            analytics()
            
            Database.database().reference().child("Users").observe(DataEventType.childAdded) { snapshot in
                if let value = snapshot.value as? [String : Any] {
                    let user = RestaurantOwner()
                    user.fcmToken = value["fcmToken"] as? String ?? "eNO6r2eVWUQNhEA7KmyD-7:APA91bF7DdMsq9Jq0ov4uW3_9nr0wc6zeccZ14UtD3_qNV5y8GPdKaffWzCz-Vo9auckttKvXG-dqoTMOOkGfCQaKgSezsDNmyLX-APsIMsCWUgEgEqUOLWbAdaWLfUUMAEctb_SQrLI"
                    user.appId = value["appId"] as? String
                    if user.appId == Restaurant.shared.restaurantId {
                        PushNotificationSender().sendPushNotification(to: user.fcmToken!, title: "Reservation Request Update", body: "One of your app users has reqested a reservation! Be sure to check it soon")
                    }
                }
            }
            Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("reservations").child(key!).updateChildValues(params)
            addSuccessNotification()
            hideLoading()
            let alert = UIAlertController(title: "Success", message: "Your reservation has been requested!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { action in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            simpleAlert(title: "Error", message: "Please fill in all fields!")
        }
    }
    
    private func analytics() {
        let root = Database.database().reference().child("Analytics").child("reservationsBooked")
        let key = root.childByAutoId().key
        let params : [String : Any] = [
            "userId" : Auth.auth().currentUser?.uid ?? "newUser",
            "restaurantId" : Restaurant.shared.restaurantId,
            "time" : Int(Date().timeIntervalSince1970)
        ]
        let feed : [String : Any] = [
            key! : params
        ]
        root.updateChildValues(feed)
        print("success logging analytics")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func getLastName() {
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(Auth.auth().currentUser!.uid).child("lastName").observe(DataEventType.value) { snapshot in
            if let value = snapshot.value as? String {
                self.lastName = value
            }
        }
    }
    
    @objc func startTimePickerValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        self.startTime = sender.date
        startTimeTF.text = formatter.string(from: sender.date)
        clear3 = true
    }
    
    @objc func endTimePickerValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm"
        self.endTime = sender.date
        endTimeTF.text = formatter.string(from: sender.date)
        clear4 = true
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        self.date = sender.date
        dateTF.text = formatter.string(from: sender.date)
        clear1 = true
    }

}
