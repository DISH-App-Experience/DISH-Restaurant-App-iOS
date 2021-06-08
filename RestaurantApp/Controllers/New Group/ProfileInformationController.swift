//
//  ProfileInformationController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/8/21.
//

import UIKit

class ProfileInformationController: UIViewController {
    
    var id : String? {
        didSet {
            
        }
    }
    
    var navTitle : String? {
        didSet {
            navigationItem.title = navTitle!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Restaurant.shared.backgroundColor
        
        updateViewConstraints()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        //
    }
    
    func backend() {
        
    }

}
