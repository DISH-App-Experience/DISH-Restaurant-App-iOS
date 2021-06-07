//
//  HomeController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/7/21.
//

import UIKit
import Firebase
import SDWebImage

class HomeController: UIViewController {
    
    let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    let welcomeLabel : UILabel = {
        let label = UILabel()
        label.text = "Hi there!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    let profileImage : UIButton = {
        let button = UIButton()
        button.backgroundColor = Restaurant.shared.themeColor
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(profileImagePressed), for: UIControl.Event.touchUpInside)
        button.layer.cornerRadius = 17.5
        return button
    }()
    
    let alertView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Restaurant.shared.themeColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    let alertImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 22.5
        imageView.clipsToBounds = true
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    let alertLabel : UILabel = {
        let label = UILabel()
        label.text = "Hi there!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = Restaurant.shared.textColorOnButton
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    let alertDescription : UILabel = {
        let label = UILabel()
        label.text = "Hi there!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = Restaurant.shared.textColorOnButton
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Restaurant.shared.backgroundColor
        
        updateViewConstraints()
        
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
        
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 1000)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        scrollView.addSubview(welcomeLabel)
        welcomeLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 71).isActive = true
        welcomeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        welcomeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        scrollView.addSubview(profileImage)
        profileImage.topAnchor.constraint(equalTo: welcomeLabel.topAnchor).isActive = true
        profileImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 35).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        scrollView.addSubview(alertView)
        alertView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 39).isActive = true
        alertView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        alertView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        alertView.heightAnchor.constraint(equalToConstant: 66).isActive = true
        
        alertView.addSubview(alertImage)
        alertImage.topAnchor.constraint(equalTo: alertView.topAnchor, constant: -11).isActive = true
        alertImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -11).isActive = true
        alertImage.heightAnchor.constraint(equalToConstant: 45).isActive = true
        alertImage.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        alertView.addSubview(alertLabel)
        alertLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 12).isActive = true
        alertLabel.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 18).isActive = true
        alertLabel.rightAnchor.constraint(equalTo: alertImage.leftAnchor, constant: -5).isActive = true
        alertLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        alertView.addSubview(alertDescription)
        alertDescription.topAnchor.constraint(equalTo: alertLabel.bottomAnchor).isActive = true
        alertDescription.leftAnchor.constraint(equalTo: alertLabel.leftAnchor).isActive = true
        alertDescription.rightAnchor.constraint(equalTo: alertLabel.rightAnchor).isActive = true
        alertDescription.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    private func backend() {
        
        let id = Restaurant.shared.restaurantId
        
        Database.database().reference().child("Apps").child(id).child("Users").child(Auth.auth().currentUser!.uid).child("firstName").observe(DataEventType.value) { snapshot in
            if let value = snapshot.value as? String {
                self.welcomeLabel.text = "Hi, " + value + "!"
            } else {
                self.welcomeLabel.text = "Hi there!"
            }
        }
        
        Database.database().reference().child("Apps").child(id).child("Users").child(Auth.auth().currentUser!.uid).child("gender").observe(DataEventType.value) { snapshot in
            if let value = snapshot.value as? String {
                if value != "Male" {
                    self.profileImage.setImage(UIImage(named: "femaleuser"), for: UIControl.State.normal)
                } else {
                    self.profileImage.setImage(UIImage(named: "maleuser"), for: UIControl.State.normal)
                }
            } else {
                self.profileImage.setImage(UIImage(named: "maleuser"), for: UIControl.State.normal)
            }
        }
        
        alertImage.sd_setImage(with: URL(string: Restaurant.shared.logo)!, completed: nil)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let weekday = formatter.string(from: Date())
        alertLabel.text = "Happy \(weekday)!"
        
        switch weekday {
            case "Monday":
                alertDescription.text = "How about starting the week with \(Restaurant.shared.name)?"
            case "Tuesday":
                alertDescription.text = "It's only Tuesday?! Speed up with a delicous meal!"
            case "Wednesday":
                alertDescription.text = "You're halfway through the week!"
            case "Thursday":
                alertDescription.text = "One day 'til Friday! Aren't you excited?"
            case "Friday":
                alertDescription.text = "TGIF!! You're made it through the week!"
            case "Saturday":
                alertDescription.text = "Weekend treat at \(Restaurant.shared.name)?"
            case "Sunday":
                alertDescription.text = "Enjoy the last bits of the weekend at \(Restaurant.shared.name)"
            default:
                alertDescription.text = "If you want a rainbow, you'll have to put up with the rain! Keep going!!"
        }
    }
    
    @objc func profileImagePressed() {
        print("to profile")
    }

}
