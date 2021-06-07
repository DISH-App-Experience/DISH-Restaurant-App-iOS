//
//  LoadingController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/6/21.
//

import UIKit
import Firebase

class LoadingController: UIViewController {
    
    let logoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "appIcon")
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        updateViewConstraints()
        backend()

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
        logoImageView.widthAnchor.constraint(equalToConstant: 93).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 93).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func backend() {
        showLoading()
        let id = Restaurant.shared.restaurantId
        Database.database().reference().child("Apps").child(id).child("theme").child("backgroundColor").observe(DataEventType.value) { snapshot in
            if let value = snapshot.value as? String {
                Restaurant.shared.backgroundColor = UIColor(hexString: value)
                Database.database().reference().child("Apps").child(id).child("theme").child("textColor").observe(DataEventType.value) { snapshot in
                    if let value = snapshot.value as? String {
                        Restaurant.shared.textColor = UIColor(hexString: value)
                        Database.database().reference().child("Apps").child(id).child("theme").child("themeColor").observe(DataEventType.value) { snapshot in
                            if let value = snapshot.value as? String {
                                Restaurant.shared.themeColor = UIColor(hexString: value)
                                Database.database().reference().child("Apps").child(id).child("appIcon").observe(DataEventType.value) { snapshot in
                                    if let value = snapshot.value as? String {
                                        Restaurant.shared.logo = value
                                        Database.database().reference().child("Apps").child(id).child("name").observe(DataEventType.value) { snapshot in
                                            if let value = snapshot.value as? String {
                                                Restaurant.shared.name = value
                                                Database.database().reference().child("Apps").child(id).child("theme").child("themeColorOnButton").observe(DataEventType.value) { snapshot in
                                                    if let value = snapshot.value as? String {
                                                        Restaurant.shared.textColorOnButton = UIColor(hexString: value)
                                                        self.hideLoading()
                                                        self.completion()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func completion() {
        if Auth.auth().currentUser != nil {
            moveToController(controller: Home())
        } else {
            moveToController(controller: WelcomeController())
        }
    }

}
