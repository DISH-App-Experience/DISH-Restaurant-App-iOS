//
//  RewardsController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/7/21.
//

import UIKit

class RewardsController: UIViewController {
    
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
        label.text = "13"
        return label
    }()
    
    let floatingActionButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = Restaurant.shared.themeColor
        button.layer.cornerRadius = 28
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.white
        button.imageView?.tintColor = UIColor.white
        button.addTarget(self, action: #selector(showScanController), for: UIControl.Event.touchUpInside)
        button.setImage(UIImage(systemName: "camera")!, for: UIControl.State.normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViewConstraints()
        
        view.backgroundColor = Restaurant.shared.backgroundColor

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
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
    }
    
    @objc func showScanController() {
        let controller = ScanController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
