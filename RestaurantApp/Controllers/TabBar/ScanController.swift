//
//  ScanController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/19/21.
//

import UIKit
import ARKit
import Firebase
import BLTNBoard
import AVFoundation

class ScanController: UIViewController, ARSCNViewDelegate {
    
    private let sceneView : ARSCNView = {
        let sceneView = ARSCNView()
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        return sceneView
    }()
    
    private let backButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: UIControl.State.normal)
        button.backgroundColor = UIColor.white
        button.tintColor = UIColor.black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(popViewController), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    private let cameraView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = Restaurant.shared.backgroundColor
        imageView.layer.cornerRadius = 25
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViewConstraints()
        
        view.backgroundColor = Restaurant.shared.themeColor

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        let configuration = ARImageTrackingConfiguration()
        let images = ARReferenceImage.referenceImages(inGroupNamed: "scannable", bundle: nil)
        configuration.trackingImages = images!
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
        
        sceneView.session.pause()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        view.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 29).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 11).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(cameraView)
        cameraView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 60).isActive = true
        cameraView.heightAnchor.constraint(equalToConstant: 285).isActive = true
        cameraView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cameraView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(sceneView)
        sceneView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        sceneView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        sceneView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        cameraSetup()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let name = imageAnchor.referenceImage.name!
        if name == "-MaFTALGYLV0JFQYyr3P" {
            showPopUp()
        }
    }
    
    private func cameraSetup() {
        sceneView.delegate = self
        sceneView.showsStatistics = true
    }
    
    private func showPopUp() {
        addSuccessNotification()
        let bulletinManager : BLTNItemManager = {
            let page = BLTNPageItem(title: "QR Found!")
            page.actionHandler = { (item: BLTNActionItem) in
                print("hi there")
            }
            page.alternativeHandler = { (item: BLTNActionItem) in
                print("hi there")
            }
            page.requiresCloseButton = false
            page.descriptionText = "Add 1 Scan to your visit?"
            page.actionButtonTitle = "Add 1 Visit"
            page.appearance.actionButtonColor = Restaurant.shared.themeColor
            page.appearance.actionButtonTitleColor = Restaurant.shared.textColorOnButton
            page.appearance.alternativeButtonTitleColor = Restaurant.shared.textColor
            page.alternativeButtonTitle = "Not now"
            return BLTNItemManager(rootItem: page)
        }()
        bulletinManager.backgroundViewStyle = BLTNBackgroundViewStyle.blurredDark
        DispatchQueue.main.async {
            bulletinManager.showBulletin(above: self)
        }
    }
    
    private func analytics() {
        let root = Database.database().reference().child("Analytics").child("rewardsCardsScans")
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
    
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
