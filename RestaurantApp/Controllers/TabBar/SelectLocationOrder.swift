//
//  SelectLocationOrder.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 8/14/21.
//

import UIKit
import Firebase

class SelectLocationOrder: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var locations = [Location]()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Choose your\nLocation"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = Restaurant.shared.textColor
        label.numberOfLines = 3
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.alwaysBounceVertical = false
        tableView.alwaysBounceHorizontal = false
        tableView.register(OrderLocationCell.self, forCellReuseIdentifier: OrderLocationCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Your Order"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        view.backgroundColor = Restaurant.shared.backgroundColor
        
        updateViewConstraints()
        
        backend()

        // Do any additional setup after loading the view.
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 62).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 51).isActive = true
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
    }
    
    private func backend() {
        showLoading()
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("locations").observe(DataEventType.childAdded) { snapshot in
            if let value = snapshot.value as? [String : Any] {
                let location = Location()
                location.city = value["city"] as? String
                location.image = value["image"] as? String
                location.lat = value["lat"] as? Double
                location.long = value["long"] as? Double
                location.state = value["state"] as? String
                location.street = value["street"] as? String
                location.zip = value["zip"] as? Int
                location.key = snapshot.key
                self.locations.append(location)
            }
            self.tableView.reloadData()
            self.hideLoading()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderLocationCell.identifier, for: indexPath) as! OrderLocationCell
        cell.titleLabel.text = locations[indexPath.row].street!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = DineTypeController()
        controller.location = self.locations[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

}
