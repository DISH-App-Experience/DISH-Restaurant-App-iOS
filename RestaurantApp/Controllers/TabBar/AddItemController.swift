//
//  AddItemController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 8/17/21.
//

import UIKit
import Firebase

class AddItemController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items = [MenuItem]()
    
    public var tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Restaurant.shared.backgroundColor
        
        updateViewConstraints()

        // Do any additional setup after loading the view.
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuItemCell.self, forCellReuseIdentifier: MenuItemCell.identifier)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        backend()
    }
    
    private func backend() {
        checkItems()
    }
    
    private func checkItems() {
        showLoading()
        items.removeAll()
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("menu").child("items").observe(DataEventType.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let item = MenuItem()
                item.title = value["title"] as? String
                item.desc = value["description"] as? String
                item.price = value["price"] as? Double
                item.category = value["category"] as? String
                item.imageUrl = value["image"] as? String
                item.scanPrice = value["scanPrice"] as? Int
                item.timestamp = value["time"] as? Int
                item.key = value["key"] as? String ?? snapshot.key
                self.items.append(item)
            }
            DispatchQueue.main.async {
                let sortedList = self.items.sorted(by: { $1.timestamp! < $0.timestamp! } )
                self.items.removeAll()
                self.items = sortedList
                self.tableView.reloadData()
                self.hideLoading()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemCell.identifier, for: indexPath) as! MenuItemCell
        
        if let imageUrl = items[indexPath.row].imageUrl {
            cell.itemImageView.sd_setImage(with: URL(string: imageUrl)!)
        }
        
        if let title = items[indexPath.row].title {
            cell.itemTitleLabel.text = title
        }
        
        if let desc = items[indexPath.row].desc {
            cell.itemDescLabel.text = desc
        }
        
        if let price = items[indexPath.row].price {
            cell.itemPriceLabel.text = "$\(price)"
        }
        
        if let category = items[indexPath.row].category {
            Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("menu").child("categories").child(category).child("name").observe(DataEventType.value) { (snapshot) in
                if let value = snapshot.value as? String {
                    cell.itemCatLabel.text = "(\(value))"
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = CustomizeItemOrderController()
        controller.item = self.items[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }

}
