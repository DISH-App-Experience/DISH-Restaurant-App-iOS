//
//  SuccessScreen.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 8/25/21.
//

import UIKit
import Firebase
import SPConfetti

class SuccessScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var bundle : OrderBundle? {
        didSet {
            if let bundle = bundle {
                // location
                var locationStreetName = ""
                if let location = bundle.location {
                    if let streetAddress = location.street {
                        locationStreetName = streetAddress
                        self.locationLabel.text = streetAddress
                    }
                }
                
                // dine type
                var dineTypeString = ""
                if let dineType = bundle.dineType {
                    switch dineType {
                    case DineType.dineIn:
                        dineTypeString = "Dine In"
                        self.dineTypeLabel.text = "Dine In"
                    case DineType.takeOut:
                        dineTypeString = "Take Out"
                        self.dineTypeLabel.text = "Take Out"
                    }
                }
                
                // time
                var validationString = ""
                let time = bundle.time
                let formatter = DateFormatter()
                formatter.dateFormat = "E, MMM. d, h:mma"
                validationString.append(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(Double(time)))))
                validationString.append(" @ ")
                validationString.append(locationStreetName)
                self.validationLabel.text = validationString
                
                var itemsString = ""
                for item in bundle.orderItems {
                    itemsString.append("\(item.menuItem!.title!), ")
                }
                
                let key = Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("orders").childByAutoId().key
                let parameters : [String : Any] = [
                    "key" : key!,
                    "dineType" : dineTypeString,
                    "user" : bundle.uid,
                    "location" : bundle.location!.key!,
                    "paymentType" : "\(bundle.paymentType!)",
                    "time" : bundle.time,
                    "menuItems" : itemsString
                ]
                let feed : [String : Any] = [
                    "\(key!)" : parameters
                ]
                Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("orders").updateChildValues(feed)
            }
        }
    }
    
    var heightConstant : NSLayoutConstraint?
    
    let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    let cashierLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.textColor = Restaurant.shared.textColor
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "Please show the cashier for confirmation"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let logoImageView : MainImageView = {
        let imageView = MainImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let yourOrderLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.textColor = Restaurant.shared.textColor
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your Order"
        return label
    }()
    
    let locationPlaceholderLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Location:"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    let dineTypePlaceholderLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Dine Type:"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    let locationLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Anything Here"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.systemGray
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    let dineTypeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Anything Here"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.systemGray
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Restaurant.shared.backgroundColor
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.alwaysBounceVertical = false
        tableView.isScrollEnabled = false
        tableView.alwaysBounceHorizontal = false
        tableView.register(OrderCell.self, forCellReuseIdentifier: OrderCell.identifier)
        return tableView
    }()
    
    let mainButton : MainButton = {
        let button = MainButton()
        button.backgroundColor = Restaurant.shared.themeColor
        button.setTitle("Done", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(mainButtonPressed), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let validationLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.textColor = Restaurant.shared.textColor
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "TIME"
        label.translatesAutoresizingMaskIntoConstraints = false
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
        
        backend()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 900)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        scrollView.addSubview(cashierLabel)
        cashierLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 9).isActive = true
        cashierLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        cashierLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        cashierLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        scrollView.addSubview(logoImageView)
        logoImageView.topAnchor.constraint(equalTo: cashierLabel.bottomAnchor, constant: 21).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 91).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 91).isActive = true
        
        scrollView.addSubview(yourOrderLabel)
        yourOrderLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 26).isActive = true
        yourOrderLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        yourOrderLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        yourOrderLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        scrollView.addSubview(locationPlaceholderLabel)
        locationPlaceholderLabel.topAnchor.constraint(equalTo: yourOrderLabel.bottomAnchor, constant: 39).isActive = true
        locationPlaceholderLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        locationPlaceholderLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        locationPlaceholderLabel.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        scrollView.addSubview(dineTypePlaceholderLabel)
        dineTypePlaceholderLabel.topAnchor.constraint(equalTo: locationPlaceholderLabel.bottomAnchor, constant: 9).isActive = true
        dineTypePlaceholderLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        dineTypePlaceholderLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        dineTypePlaceholderLabel.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        scrollView.addSubview(locationLabel)
        locationLabel.topAnchor.constraint(equalTo: yourOrderLabel.bottomAnchor, constant: 39).isActive = true
        locationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        locationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        scrollView.addSubview(dineTypeLabel)
        dineTypeLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 9).isActive = true
        dineTypeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        dineTypeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        dineTypeLabel.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.topAnchor.constraint(equalTo: dineTypeLabel.bottomAnchor, constant: 21).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        heightConstant = tableView.heightAnchor.constraint(equalToConstant: 120)
        
        view.addSubview(mainButton)
        mainButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        scrollView.addSubview(validationLabel)
        validationLabel.topAnchor.constraint(equalTo: mainButton.bottomAnchor, constant: 9).isActive = true
        validationLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        validationLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        validationLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
    }
    
    private func backend() {
        logoImageView.loadImage(from: URL(string: Restaurant.shared.logo)!)
    }
    
    func addConfetti() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            SPConfetti.startAnimating(.fullWidthToDown, particles: [.triangle, .arc, .circle, .polygon, .star], duration: 1)
        }
    }
    
    func analytics() {
        let root = Database.database().reference().child("Analytics").child("ordersPlaced")
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let objectCount = orderObjects.count
        heightConstant!.constant = (CGFloat(Int(objectCount) * 92) + 10)
        heightConstant!.isActive = true
        return objectCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.identifier, for: indexPath) as! OrderCell
        cell.titleLabel.text = "\(orderObjects[indexPath.row].menuItem!.title!) | \(orderObjects[indexPath.row].menuItem!.price!)"
        cell.descLabel.text = orderObjects[indexPath.row].menuItem!.desc!
        cell.itemImageView.sd_setImage(with: URL(string: orderObjects[indexPath.row].menuItem!.imageUrl!)!, completed: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    @objc func mainButtonPressed() {
        self.dismiss(animated: true) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

}
