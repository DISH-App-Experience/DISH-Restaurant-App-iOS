//
//  Home.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/6/21.
//

import UIKit
import Firebase

class TabBarController: UITabBarController {
    
    let homeController = UINavigationController(rootViewController: HomeController())
    
    let menuController = UINavigationController(rootViewController: MenuController())
    
    let rewardsController = UINavigationController(rootViewController: RewardsController())
    
    let actionController = UINavigationController(rootViewController: ActionController())
    
    let reservationController = UINavigationController(rootViewController: ReservationController())
    
    var appId = Restaurant.shared.restaurantId
    
    var navigationControllers = [UINavigationController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = Restaurant.shared.themeColor
        tabBar.barTintColor = Restaurant.shared.secondaryBackground
        
        hidesBottomBarWhenPushed = true
        
        tabBarCustomization()
        
        // Do any additional setup after loading the view.
    }
    
    func tabBarCustomization() {
        homeController.tabBarItem.image = UIImage(systemName: "house")
        homeController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        menuController.tabBarItem.image = UIImage(systemName: "book")
        menuController.tabBarItem.selectedImage = UIImage(systemName: "book.fill")
        
        rewardsController.tabBarItem.image = UIImage(systemName: "crown")
        rewardsController.tabBarItem.selectedImage = UIImage(systemName: "crown.fill")
        
        actionController.tabBarItem.image = UIImage(systemName: "message")
        actionController.tabBarItem.selectedImage = UIImage(systemName: "message.fill")
        
        reservationController.tabBarItem.image = UIImage(systemName: "calendar.badge.clock")
        reservationController.tabBarItem.selectedImage = UIImage(systemName: "calendar.badge.clock")
    }
    
    func checkControllers() {
        navigationControllers.append(homeController)
        navigationControllers.append(menuController)
        Database.database().reference().child("Apps").child(appId).child("features").child("newsEvents").observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? Bool {
                if value {
                    self.navigationControllers.append(self.actionController)
                    self.checkRewards()
                } else {
                    self.checkAnotherAction()
                }
            }
        }
    }
    
    func checkAnotherAction() {
        Database.database().reference().child("Apps").child(self.appId).child("features").child("sendPromos").observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? Bool {
                if value {
                    self.navigationControllers.append(self.actionController)
                    self.checkRewards()
                } else {
                    self.checkRewards()
                }
            }
        }
    }
    
    func checkRewards() {
        Database.database().reference().child("Apps").child(self.appId).child("features").child("rewardProgram").observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? Bool {
                if value {
                    self.navigationControllers.append(self.rewardsController)
                    self.checkReservations()
                } else {
                    self.checkReservations()
                }
            }
        }
    }
    
    func checkReservations() {
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("features").child("reservationRequests").observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? Bool {
                if value {
                    self.navigationControllers.append(self.reservationController)
                    self.viewControllers = self.navigationControllers
                } else {
                    self.viewControllers = self.navigationControllers
                }
            }
        }
    }
    
}
