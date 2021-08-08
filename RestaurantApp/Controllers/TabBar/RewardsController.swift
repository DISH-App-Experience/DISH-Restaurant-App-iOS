//
//  RewardsController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/7/21.
//

import UIKit
import Firebase

class RewardsController: UIViewController {
    
    var locations = [Location]()
    
    let topBanner : UIView = {
        let view = UIView()
        view.backgroundColor = Restaurant.shared.themeColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    let totalScansLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 75)
        label.textAlignment = NSTextAlignment.center
        label.textColor = Restaurant.shared.textColorOnButton
        label.text = "0"
        return label
    }()
    
    let scansLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = NSTextAlignment.center
        label.textColor = Restaurant.shared.textColorOnButton
        label.text = "Total Scans"
        return label
    }()
    
    let floatingActionButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = Restaurant.shared.themeColor
        button.layer.cornerRadius = 28
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.white
        button.imageView?.tintColor = Restaurant.shared.textColorOnButton
        button.addTarget(self, action: #selector(showScanController), for: UIControl.Event.touchUpInside)
        button.setImage(UIImage(systemName: "camera")!, for: UIControl.State.normal)
        return button
    }()
    
    let bigViewSingle : UIView = {
        let view = UIView()
        view.backgroundColor = Restaurant.shared.backgroundColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 50
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let rewardTitle : UILabel = {
        let label = UILabel()
        label.text = "Free ITEM"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.left
        label.textColor = Restaurant.shared.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let secondaryBackColor : UIView = {
        let view = UIView()
        view.backgroundColor = Restaurant.shared.secondaryBackground
        view.layer.cornerRadius = 13.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViewConstraints()
        
        view.backgroundColor = Restaurant.shared.backgroundColor

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        backend()
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
//        navigationController?.navigationBar.isHidden = false
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        view.addSubview(topBanner)
        topBanner.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topBanner.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topBanner.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topBanner.heightAnchor.constraint(equalToConstant: 380).isActive = true
        
        view.addSubview(floatingActionButton)
        floatingActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
        floatingActionButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        floatingActionButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        floatingActionButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        view.addSubview(totalScansLabel)
        totalScansLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 143).isActive = true
        totalScansLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        totalScansLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        totalScansLabel.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        view.addSubview(scansLabel)
        scansLabel.topAnchor.constraint(equalTo: totalScansLabel.bottomAnchor, constant: 6).isActive = true
        scansLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scansLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scansLabel.heightAnchor.constraint(equalToConstant: 27).isActive = true
    }
    
    @objc func showScanController() {
        let controller = ScanController()
        add3DMotion(withFeedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle.medium)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func backend() {
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(Auth.auth().currentUser!.uid).child("totalScans").observe(DataEventType.value) { snapshot in
            if let value = snapshot.value as? Int {
                self.totalScansLabel.text = String(value)
            } else {
                self.totalScansLabel.text = "0"
            }
        }
        
        locations.removeAll()
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("locations").observe(DataEventType.childAdded) { snapchat in
            if let value = snapchat.value as? [String : Any] {
                let location = Location()
                location.city = value["city"] as? String
                location.image = value["image"] as? String
                location.lat = value["lat"] as? Double
                location.long = value["long"] as? Double
                location.state = value["state"] as? String
                location.street = value["street"] as? String
                location.zip = value["zip"] as? Int
                self.locations.append(location)
            }
//            if self.locations.count > 1 {
//                self.setupMultiple()
//            } else {
                self.setupSingle()
//            }
            
        }
    }
    
    private func setupMultiple() {
        
    }
    
    private func setupSingle() {
        view.addSubview(bigViewSingle)
        bigViewSingle.topAnchor.constraint(equalTo: topBanner.bottomAnchor, constant: 30).isActive = true
        bigViewSingle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        bigViewSingle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        bigViewSingle.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        bigViewSingle.addSubview(rewardTitle)
        rewardTitle.topAnchor.constraint(equalTo: bigViewSingle.topAnchor, constant: 16).isActive = true
        rewardTitle.leftAnchor.constraint(equalTo: bigViewSingle.leftAnchor, constant: 16).isActive = true
        rewardTitle.rightAnchor.constraint(equalTo: bigViewSingle.rightAnchor, constant: -16).isActive = true
        rewardTitle.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
        view.addSubview(secondaryBackColor)
        secondaryBackColor.topAnchor.constraint(equalTo: rewardTitle.bottomAnchor, constant: 13).isActive = true
        secondaryBackColor.leftAnchor.constraint(equalTo: bigViewSingle.leftAnchor, constant: 16).isActive = true
        secondaryBackColor.rightAnchor.constraint(equalTo: bigViewSingle.rightAnchor, constant: -16).isActive = true
        secondaryBackColor.heightAnchor.constraint(equalToConstant: 27).isActive = true
    }

}
