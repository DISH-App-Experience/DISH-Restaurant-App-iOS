//
//  MenuController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/7/21.
//

import UIKit
import Firebase

enum MenuLayout {
    case table, grid
}

class MenuController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    var layout = MenuLayout.table {
        didSet {
            if layout == MenuLayout.table {
                UIView.animate(withDuration: 0.5) {
                    self.menuCollectionView!.alpha = 0
                } completion: { completion in
                    if completion {
                        UIView.animate(withDuration: 0.5) {
                            self.tableView.alpha = 1
                        }
                    }
                }
            } else if layout == MenuLayout.grid {
                UIView.animate(withDuration: 0.5) {
                    self.tableView.alpha = 0
                } completion: { completion in
                    if completion {
                        UIView.animate(withDuration: 0.5) {
                            self.menuCollectionView!.alpha = 1
                        }
                    }
                }
            }
        }
    }
    
    var categories = [Category]()
    
    var chosenCategory = "All Items"
    
    var chosenCategoryBig : Category?
    
    var items = [MenuItem]()
    
    var otherCatItems = [MenuItem]()
    
    var isOutsideAll = false
    
    var outsideCat : Category?
    
    var categoryCollectionView : UICollectionView?
    
    var menuCollectionView : UICollectionView?
    
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        backend()
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = Restaurant.shared.themeColor
        
        navigationItem.title = "Menu"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left.arrow.right")!, style: UIBarButtonItem.Style.done, target: self, action: #selector(changeLayout))
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        categoryCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        if let cCV = categoryCollectionView {
            cCV.backgroundColor = Restaurant.shared.backgroundColor
            cCV.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(cCV)
            cCV.delegate = self
            cCV.showsHorizontalScrollIndicator = false
            cCV.alwaysBounceHorizontal = true
            cCV.alwaysBounceVertical = false
            cCV.register(MenuCategoryCell.self, forCellWithReuseIdentifier: MenuCategoryCell.identifier)
            cCV.dataSource = self
            cCV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17).isActive = true
            cCV.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
            cCV.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            cCV.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuItemCell.self, forCellReuseIdentifier: MenuItemCell.identifier)
        tableView.topAnchor.constraint(equalTo: categoryCollectionView!.bottomAnchor, constant: 27).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
        
        let layou2: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layou2.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layou2.scrollDirection = .vertical
        menuCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layou2)
        if let mCV = menuCollectionView {
            mCV.backgroundColor = Restaurant.shared.backgroundColor
            mCV.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(mCV)
            mCV.delegate = self
            mCV.showsVerticalScrollIndicator = false
            mCV.alwaysBounceHorizontal = false
            mCV.alwaysBounceVertical = true
            mCV.register(MenuItemCVCell.self, forCellWithReuseIdentifier: MenuItemCVCell.identifier)
            mCV.dataSource = self
            mCV.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
            mCV.leftAnchor.constraint(equalTo: tableView.leftAnchor).isActive = true
            mCV.rightAnchor.constraint(equalTo: tableView.rightAnchor).isActive = true
            mCV.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        }
    }
    
    private func backend() {
        if UserDefaults.standard.string(forKey: "menuLayout") == "table" {
            layout = MenuLayout.table
        } else {
            layout = MenuLayout.grid
        }
        checkCategories()
        checkItems()
    }
    
    private func checkCategories() {
        showLoading()
        categories.removeAll()
        let all = Category()
        all.name = "All Items"
        all.key = "All Items"
        all.selected = true
        categories.append(all)
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("menu").child("categories").observe(DataEventType.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let category = Category()
                category.name = value["name"] as? String
                category.key = value["key"] as? String
                category.selected = false
                self.categories.append(category)
            }
            DispatchQueue.main.async {
                self.categoryCollectionView!.reloadData()
            }
            self.hideLoading()
        }
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
                item.timestamp = value["time"] as? Int
                item.key = value["key"] as? String ?? snapshot.key
                self.items.append(item)
            }
            DispatchQueue.main.async {
                let sortedList = self.items.sorted(by: { $1.timestamp! < $0.timestamp! } )
                self.items.removeAll()
                self.items = sortedList
                self.tableView.reloadData()
                self.menuCollectionView!.reloadData()
                self.hideLoading()
            }
        }
    }
    
    @objc func changeLayout() {
        if layout == MenuLayout.table {
            layout = MenuLayout.grid
            UserDefaults.standard.setValue("grid", forKey: "menuLayout")
        } else {
            layout = MenuLayout.table
            UserDefaults.standard.setValue("table", forKey: "menuLayout")
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.categoryCollectionView! {
            return categories.count
        } else {
            if isOutsideAll {
                return otherCatItems.count
            } else {
                return items.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.categoryCollectionView! {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCategoryCell.identifier, for: indexPath) as! MenuCategoryCell
            cell.backgroundColor = Restaurant.shared.secondaryBackground
            cell.layer.cornerRadius = 10
            cell.category = categories[indexPath.row]
            if categories[indexPath.row].selected! {
                cell.layer.borderColor = Restaurant.shared.themeColor.cgColor
                cell.layer.borderWidth = 2
            } else {
                cell.layer.borderWidth = 0
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuItemCVCell.identifier, for: indexPath) as! MenuItemCVCell
            if isOutsideAll {
                if let imageUrl = otherCatItems[indexPath.row].imageUrl {
                    cell.itemImageView.sd_setImage(with: URL(string: imageUrl)!)
                }
                
                if let title = otherCatItems[indexPath.row].title {
                    cell.itemTitleLabel.text = title
                }
                
                if let desc = otherCatItems[indexPath.row].desc {
                    cell.itemDescLabel.text = desc
                }
                
                if let price = otherCatItems[indexPath.row].price {
                    cell.itemPriceLabel.text = "$\(price)"
                }
                
                return cell
            } else {
                
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
                
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.categoryCollectionView! {
            for category in categories {
                category.selected! = false
            }
            chosenCategory = categories[indexPath.row].name!
            categories[indexPath.row].selected = true
            chosenCategoryBig = categories[indexPath.row]
            if indexPath.item == 0 {
                isOutsideAll = false
            } else {
                isOutsideAll = true
                otherCatItems.removeAll()
                otherCatItems = items.filter { $0.category! == categories[indexPath.row].key! }
            }
            categoryCollectionView!.reloadData()
            tableView.reloadData()
            menuCollectionView!.reloadData()
        } else {
            if isOutsideAll {
                showMenuItem(menuItem: otherCatItems[indexPath.row])
            } else {
                showMenuItem(menuItem: items[indexPath.row])
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.categoryCollectionView! {
            return CGSize(width: estimateFrameForText(text: categories[indexPath.row].name!).width + 30, height: 44)
        } else {
            print("calc size")
            return CGSize(width: (self.menuCollectionView!.frame.size.width / 2) - 10, height: 192)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isOutsideAll {
            return otherCatItems.count
        } else {
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isOutsideAll {
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemCell.identifier, for: indexPath) as! MenuItemCell
            
            if let imageUrl = otherCatItems[indexPath.row].imageUrl {
                cell.itemImageView.sd_setImage(with: URL(string: imageUrl)!)
            }
            
            if let title = otherCatItems[indexPath.row].title {
                cell.itemTitleLabel.text = title
            }
            
            if let desc = otherCatItems[indexPath.row].desc {
                cell.itemDescLabel.text = desc
            }
            
            if let price = otherCatItems[indexPath.row].price {
                cell.itemPriceLabel.text = "$\(price)"
            }
            
            if let category = otherCatItems[indexPath.row].category {
                Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("menu").child("categories").child(category).child("name").observe(DataEventType.value) { (snapshot) in
                    if let value = snapshot.value as? String {
                        cell.itemCatLabel.text = "(\(value))"
                    }
                }
            }
            
            return cell
        } else {
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isOutsideAll {
            showMenuItem(menuItem: otherCatItems[indexPath.row])
        } else {
            showMenuItem(menuItem: items[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }

}
