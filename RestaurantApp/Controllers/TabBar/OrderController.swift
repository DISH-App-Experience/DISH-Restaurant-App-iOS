//
//  OrderController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 8/17/21.
//

import UIKit

var orderObjects = [OrderObject]()

class OrderController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var location : Location?
    
    var dineType : DineType?
    
    var timer: Timer!
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Your\nOrder"
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
        tableView.backgroundColor = Restaurant.shared.backgroundColor
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.alwaysBounceVertical = false
        tableView.alwaysBounceHorizontal = false
        tableView.register(OrderCell.self, forCellReuseIdentifier: OrderCell.identifier)
        return tableView
    }()
    
    let checkoutMainButton : MainButton = {
        let button = MainButton()
        button.backgroundColor = Restaurant.shared.themeColor
        button.addTarget(self, action: #selector(mainButtonPressed), for: UIControl.Event.touchUpInside)
        button.setTitle("Checkout", for: UIControl.State.normal)
        return button
    }()
    
    let floatingActionAdd : MainFAB = {
        let button = MainFAB()
        button.setImage(UIImage(systemName: "plus"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(fabPressed), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = Restaurant.shared.textColor
        label.numberOfLines = 2
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Your Order"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        view.backgroundColor = Restaurant.shared.backgroundColor
        
        updateViewConstraints()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.priceCheck), userInfo: nil, repeats: true)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 62).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 51).isActive = true
        
        view.addSubview(checkoutMainButton)
        checkoutMainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
        checkoutMainButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        checkoutMainButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        checkoutMainButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(floatingActionAdd)
        floatingActionAdd.bottomAnchor.constraint(equalTo: checkoutMainButton.topAnchor, constant: -16).isActive = true
        floatingActionAdd.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        floatingActionAdd.widthAnchor.constraint(equalToConstant: 56).isActive = true
        floatingActionAdd.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        view.addSubview(priceLabel)
        priceLabel.bottomAnchor.constraint(equalTo: floatingActionAdd.bottomAnchor).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: floatingActionAdd.leftAnchor, constant: 10).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        priceLabel.heightAnchor.constraint(equalTo: floatingActionAdd.heightAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        tableView.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -16).isActive = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let objects = orderObjects.count
        if objects == 0 {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }
        return orderObjects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.identifier, for: indexPath) as! OrderCell
        cell.titleLabel.text = "\(orderObjects[indexPath.row].menuItem!.title!) | \(orderObjects[indexPath.row].menuItem!.price!)"
        cell.descLabel.text = orderObjects[indexPath.row].menuItem!.desc!
        cell.itemImageView.sd_setImage(with: URL(string: orderObjects[indexPath.row].menuItem!.imageUrl!)!, completed: nil)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete?", message: "Are you sure you want to delete this menu item?", preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Yes, Delete", style: UIAlertAction.Style.destructive, handler: { action in
            orderObjects.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }))
        alert.addAction(UIAlertAction(title: "No, Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    private func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: UIContextualAction.Style.destructive, title: "Delete") { action, view, completion in
            let alert = UIAlertController(title: "Delete?", message: "Are you sure you want to delete this menu item?", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "Yes, Delete", style: UIAlertAction.Style.destructive, handler: { action in
                orderObjects.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }))
            alert.addAction(UIAlertAction(title: "No, Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        action.backgroundColor = .red
        return action
    }
    
    @objc func priceCheck() {
        var scanPrice : Double = 0
        var buyPrice : Double = 0
        for item in orderObjects {
            let itemScanPrice = item.menuItem!.scanPrice!
            let itemBuyPrice = item.menuItem!.price!
            scanPrice += Double(itemScanPrice)
            buyPrice += itemBuyPrice
        }
        priceLabel.text = "Scan Price: \(scanPrice)\nPrice: $\(buyPrice)"
    }
    
    @objc func mainButtonPressed() {
        if location != nil && dineType != nil && orderObjects.count != 0 {
            let bundle = OrderBundle()
            bundle.location = location
            bundle.dineType = dineType
            let controller = CheckoutController()
            controller.bundle = bundle
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            self.simpleAlert(title: "Error", message: "Please make sure to add order items!")
        }
    }
    
    @objc func fabPressed() {
        let controller = AddItemController()
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
