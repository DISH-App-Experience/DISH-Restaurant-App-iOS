//
//  ProfileController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/8/21.
//

import UIKit
import Firebase

class ProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let titles = ["First Name", "Last Name", "Gender", "Birthday", "Logout"]
    
    let identifiers = ["firstName", "lastName", "gender", "birthday"]
    
    var user : User? {
        didSet {
            tableView.reloadData()
        }
    }
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Restaurant.shared.backgroundColor
        
        updateViewConstraints()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "My Profile"
        navigationController?.navigationBar.isHidden = false
        
        backend()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
        
        cell.titleLabel.text = titles[indexPath.row]
        
//        if cell.titleLabel.text == "Logout" {
//            cell.titleLabel.textColor = UIColor.systemRed
//        }
        
        if user != nil {
            if let user = user {
                switch indexPath.row {
                case 0:
                    cell.responseLabel.text = user.firstName!
                case 1:
                    cell.responseLabel.text = user.lastName!
                case 2:
                    cell.responseLabel.text = user.gender!
                case 3:
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MMM d, yyyy"
                    let isoFormatter = ISO8601DateFormatter()
                    let date = isoFormatter.date(from: user.birthday!)
                    let string = formatter.string(from: date!)
                    cell.responseLabel.text = string
                default:
                    cell.responseLabel.text = ""
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            self.present(UIAlertController().customActionWithCancel(title: "Are you sure you want to Sign Out?", message: "") {
                let auth = Auth.auth()
                do {
                    try auth.signOut()
                    self.moveToWelcomeController()
                } catch let error as NSError {
                    self.simpleAlert(title: "Error", message: error.localizedDescription)
                }
            }, animated: true, completion: nil)
        } else {
            let controller = ProfileInformationController()
            controller.id = identifiers[indexPath.row]
            controller.navTitle = titles[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func backend() {
        
        var firstName = String()
        var lastName = String()
        var gender = String()
        var birthday = String()
        
        let root = Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(Auth.auth().currentUser!.uid)
        
        root.child("firstName").observe(DataEventType.value) { firstNameSS in
            firstName = firstNameSS.value as? String ?? "Error"
            root.child("lastName").observe(DataEventType.value) { lastNameSS in
                lastName = lastNameSS.value as? String ?? "Error"
                root.child("gender").observe(DataEventType.value) { genderSS in
                    gender = genderSS.value as? String ?? "Error"
                    root.child("birthday").observe(DataEventType.value) { birthdaySS in
                        birthday = birthdaySS.value as? String ?? ""
                        let user = User()
                        user.firstName = firstName
                        user.lastName = lastName
                        user.gender = gender
                        user.birthday = birthday
                        self.user = user
                    }
                }
            }
        }
    }

}
