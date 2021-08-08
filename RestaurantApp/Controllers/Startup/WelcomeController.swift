//
//  ViewController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/6/21.
//

import UIKit
import Firebase
import SDWebImage
import GoogleSignIn
import MBProgressHUD
import AuthenticationServices
import CryptoKit

class WelcomeController: UIViewController, GIDSignInDelegate, ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    
    var currentNonce : String?
    
    let logoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.backgroundColor = Restaurant.shared.secondaryBackground
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
        label.text = "Welcome!"
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    let descLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Restaurant.shared.textColor
        label.text = "How would you like to continue?"
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    let googleButton : MainButton = {
        let button = MainButton()
        button.backgroundColor = UIColor(hexString: "F2F2F2")
        button.addTarget(self, action: #selector(googleButtonPressed), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let appleButton : MainButton = {
        let button = MainButton()
        button.backgroundColor = UIColor(hexString: "000000")
        button.addTarget(self, action: #selector(appleButtonPressed), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let emailButton : MainButton = {
        let button = MainButton()
        button.backgroundColor = Restaurant.shared.themeColor
        button.setTitleColor(Restaurant.shared.textColorOnButton, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(emailButtonPressed), for: UIControl.Event.touchUpInside)
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
        
        GIDSignIn.sharedInstance().delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        backend()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        view.addSubview(logoImageView)
        logoImageView.widthAnchor.constraint(equalToConstant: 93).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 93).isActive = true
        logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(welcomeLabel)
        welcomeLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 19).isActive = true
        welcomeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        welcomeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(descLabel)
        descLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 7).isActive = true
        descLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        descLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        descLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(googleButton)
        googleButton.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 47).isActive = true
        googleButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        googleButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        googleButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        view.addSubview(appleButton)
        appleButton.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 19).isActive = true
        appleButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        appleButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        appleButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        view.addSubview(emailButton)
        emailButton.topAnchor.constraint(equalTo: appleButton.bottomAnchor, constant: 19).isActive = true
        emailButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        emailButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        emailButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        view.addSubview(signUpExtButton)
        signUpExtButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        signUpExtButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        signUpExtButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        signUpExtButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    private func backend() {
        logoImageView.sd_setImage(with: URL(string: Restaurant.shared.logo)!, completed: nil)
    }
    
    private func setupButtons() {
        let attribute1 = NSMutableAttributedString(string: "Continue with ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor.black])
        attribute1.append(NSAttributedString(string: "G", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "4285F4"), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]))
        attribute1.append(NSAttributedString(string: "o", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "EA4335"), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]))
        attribute1.append(NSAttributedString(string: "o", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "FBBC05"), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]))
        attribute1.append(NSAttributedString(string: "g", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "4285F4"), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]))
        attribute1.append(NSAttributedString(string: "l", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "34A853"), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]))
        attribute1.append(NSAttributedString(string: "e", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "EA4335"), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]))
        googleButton.setAttributedTitle(attribute1, for: UIControl.State.normal)
        
        let attribute3 = NSMutableAttributedString(string: "Continue with ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor.white])
        attribute3.append(NSAttributedString(string: "Apple", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]))
        appleButton.setAttributedTitle(attribute3, for: UIControl.State.normal)
        
        let attribute4 = NSMutableAttributedString(string: "Sign In with ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : Restaurant.shared.textColorOnButton])
        attribute4.append(NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : Restaurant.shared.textColorOnButton, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]))
        emailButton.setAttributedTitle(attribute4, for: UIControl.State.normal)
        
        let attribute5 = NSMutableAttributedString(string: "New to \(Restaurant.shared.name)? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : Restaurant.shared.textColor])
        attribute5.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.foregroundColor : Restaurant.shared.themeColor, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]))
        signUpExtButton.setAttributedTitle(attribute5, for: UIControl.State.normal)
    }
    
    @objc func googleButtonPressed() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func appleButtonPressed() {
        print("apple button pressed")
        let nonce = self.randomNonceString()
        self.currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = self.sha256(nonce)
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @objc func emailButtonPressed() {
        print("email button pressed")
        moveToController(controller: SignInController())
    }
    
    @objc func signUpExtPressed() {
        moveToController(controller: SignUpController())
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        showLoading()
        if let error = error {
            hideLoading()
            print("ERROR: \(error.localizedDescription)")
            simpleAlert(title: "Error", message: error.localizedDescription)
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (result, signInError) in
            if let error = signInError {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.simpleAlert(title: "Error", message: error.localizedDescription)
                return
            } else {
                if Auth.auth().currentUser != nil {
                    Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(Auth.auth().currentUser!.uid).observe(DataEventType.value) { (snapshot) in
                        if snapshot.exists() {
                            self.hideLoading()
                            // user is signed in
                            // user can enter official app interface
                            self.moveToTabbar()
                        } else {
                            self.hideLoading()
                            // user does not exist
                            // user will be created
                            // user is pushed to following screen
                            self.moveToInfoController(withEmail: Auth.auth().currentUser!.email!)
                        }
                    }
                }
            }
        }
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        showLoading()
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                hideLoading()
                simpleAlert(title: "Error", message: "Invalid state: A login callback was received, but no login request was sent.")
                return
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                hideLoading()
                simpleAlert(title: "Error", message: "Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                hideLoading()
                simpleAlert(title: "Unable to serialize token string from data", message: appleIDToken.debugDescription)
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    self.simpleAlert(title: "Error", message: error.localizedDescription)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    return
                } else {
                    if Auth.auth().currentUser != nil {
                        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(Auth.auth().currentUser!.uid).observe(DataEventType.value) { (snapshot) in
                            if snapshot.exists() {
                                self.hideLoading()
                                // user is signed in
                                // user can enter official app interface
                                self.moveToTabbar()
                            } else {
                                self.hideLoading()
                                // user does not exist
                                // user will be created
                                // user is pushed to following screen
                                self.moveToInfoController(withEmail: Auth.auth().currentUser!.email!)
                            }
                        }
                    }
                }
            }
        }
    }


}

