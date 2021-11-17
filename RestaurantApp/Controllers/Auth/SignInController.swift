//
//  SignInController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/6/21.
//

import UIKit
import Firebase
import AppTrackingTransparency

class SignInController: UIViewController, UITextFieldDelegate {
    
    let logoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "appIcon")
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let welcomeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = Restaurant.shared.textColor
        label.text = "Sign In"
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    let emailTextfield : MainTextField = {
        let textField = MainTextField(placeholderString: "Email")
        textField.keyboardType = UIKeyboardType.emailAddress
        return textField
    }()
    
    let passwordTextfield : MainTextField = {
        let textField = MainTextField(placeholderString: "Password")
        textField.keyboardType = UIKeyboardType.default
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let mainButton : MainButton = {
        let button = MainButton()
        button.backgroundColor = Restaurant.shared.themeColor
        button.setTitle("Sign In", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(mainButtonPressed), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let signUpExtButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(signUpExtPressed), for: UIControl.Event.touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Restaurant.shared.backgroundColor
        
        updateViewConstraints()
        setupButtons()
        appTracking()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        view.addSubview(logoImageView)
        logoImageView.widthAnchor.constraint(equalToConstant: 67).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 67).isActive = true
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 84).isActive = true
        logoImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        
        view.addSubview(welcomeLabel)
        welcomeLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 14).isActive = true
        welcomeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        welcomeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(emailTextfield)
        emailTextfield.delegate = self
        emailTextfield.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 76).isActive = true
        emailTextfield.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        emailTextfield.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        emailTextfield.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(passwordTextfield)
        passwordTextfield.delegate = self
        passwordTextfield.topAnchor.constraint(equalTo: emailTextfield.bottomAnchor, constant: 16).isActive = true
        passwordTextfield.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        passwordTextfield.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        passwordTextfield.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(mainButton)
        mainButton.topAnchor.constraint(equalTo: passwordTextfield.bottomAnchor, constant: 29).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        view.addSubview(signUpExtButton)
        signUpExtButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        signUpExtButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        signUpExtButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        signUpExtButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextfield:
            passwordTextfield.becomeFirstResponder()
        case passwordTextfield:
            textField.resignFirstResponder()
            mainButtonPressed()
        default:
            textField.resignFirstResponder()
        }
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setupButtons() {
        let attribute5 = NSMutableAttributedString(string: "New to \(Restaurant.shared.name)? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : Restaurant.shared.textColor])
        attribute5.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.foregroundColor : Restaurant.shared.themeColor, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]))
        signUpExtButton.setAttributedTitle(attribute5, for: UIControl.State.normal)
    }
    
    @objc func mainButtonPressed() {
        showLoading()
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    self.hideLoading()
                    self.simpleAlert(title: "Error", message: error.localizedDescription)
                } else {
                    // success
                    // go to home page
                    self.hideLoading()
                    self.moveToTabbar()
                }
            }
        } else {
            hideLoading()
            simpleAlert(title: "Error", message: "Please fill in all fields")
        }
    }
    
    @objc func signUpExtPressed() {
        add3DMotion(withFeedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle.light)
        moveToController(controller: SignUpController())
    }
}

extension UIViewController {
    
    func appTracking() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                print("Authorized")
            case .denied:
                print("Denied")
                ATTrackingManager.requestTrackingAuthorization { anotherStatus in
                    print("denied again")
                }
            case .notDetermined:
                print("Not Determined")
            case .restricted:
                print("Restricted")
            @unknown default:
                print("Unknown")
            }
        }
    }
}
