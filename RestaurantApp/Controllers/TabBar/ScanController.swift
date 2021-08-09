////
////  ScanController.swift
////  RestaurantApp
////
////  Created by JJ Zapata on 6/19/21.
////
//
//import UIKit
//import ARKit
//import Firebase
//import BLTNBoard
//import CoreLocation
//import AVFoundation
//
//var scannedID = ""
//
//class ScanController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {
//    
//    var locationManager : CLLocationManager!
//    
//    let boardManager : BLTNItemManager = {
//        let page = BLTNPageItem(title: "QR Found!")
//        page.actionHandler = { (item: BLTNActionItem) in
//            ScanController.completion()
//        }
//        page.requiresCloseButton = false
//        page.descriptionText = "Add 1 Scan to your visit?"
//        page.actionButtonTitle = "Add 1 Visit"
//        page.appearance.actionButtonColor = Restaurant.shared.themeColor
//        page.appearance.actionButtonTitleColor = Restaurant.shared.textColorOnButton
//        page.appearance.alternativeButtonTitleColor = Restaurant.shared.textColor
//        return BLTNItemManager(rootItem: page)
//    }()
//    
//    private let sceneView : ARSCNView = {
//        let sceneView = ARSCNView()
//        sceneView.translatesAutoresizingMaskIntoConstraints = false
//        return sceneView
//    }()
//    
//    private let backButton : UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(systemName: "chevron.left"), for: UIControl.State.normal)
//        button.backgroundColor = UIColor.white
//        button.tintColor = UIColor.black
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = 25
//        button.addTarget(self, action: #selector(popViewController), for: UIControl.Event.touchUpInside)
//        return button
//    }()
//    
//    private let cameraView : UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.backgroundColor = Restaurant.shared.backgroundColor
//        imageView.layer.cornerRadius = 25
//        return imageView
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        updateViewConstraints()
//        
//        view.backgroundColor = Restaurant.shared.themeColor
//
//        // Do any additional setup after loading the view.
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        navigationController?.navigationBar.isHidden = true
//        
//        let configuration = ARImageTrackingConfiguration()
//        let images = ARReferenceImage.referenceImages(inGroupNamed: "scannable", bundle: nil)
//        configuration.trackingImages = images!
//        sceneView.session.run(configuration)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        navigationController?.navigationBar.isHidden = false
//        
//        sceneView.session.pause()
//    }
//    
//    override func updateViewConstraints() {
//        super.updateViewConstraints()
//        
//        view.addSubview(backButton)
//        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 29).isActive = true
//        backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 11).isActive = true
//        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        backButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        
//        view.addSubview(cameraView)
//        cameraView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 60).isActive = true
//        cameraView.heightAnchor.constraint(equalToConstant: 285).isActive = true
//        cameraView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        cameraView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        
//        view.addSubview(sceneView)
//        sceneView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        sceneView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        sceneView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        
//        cameraSetup()
//    }
//    
//    private func locationServices() {
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        
//        if !CLLocationManager.locationServicesEnabled() {
//            locationManager.requestWhenInUseAuthorization()
//        }
//    }
//    
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        guard let imageAnchor = anchor as? ARImageAnchor else { return }
//        let name = imageAnchor.referenceImage.name!
//        if name == "-MaFTALGYLV0JFQYyr3P" {
//            print("elmhurst location")
//            Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("locations").child(name).child("lat").observeSingleEvent(of: DataEventType.value) { latSnap in
//                Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("locations").child(name).child("long").observeSingleEvent(of: DataEventType.value) { longSnap in
//                    if let lat = latSnap as? Double, let long = longSnap as? Double {
//                        let destination = CLLocation(latitude: lat, longitude: long)
//                        let current = CLLocation(latitude: self.locationManager.location!.coordinate.latitude, longitude: self.locationManager.location!.coordinate.longitude)
//                        let distance = current.distance(from: destination) // meters
//                        let maxRadius = 200 // meters
//                        if Int(distance) > maxRadius {
//                            self.simpleAlert(title: "Error", message: "You are too far away from the destination you claim to be at.")
//                        } else {
//                            // check if scanned again
//                            // check if scan in same location
//                            scannedID = name
//                            self.showPopUp()
//                        }
//                    } else {
//                        // check if scanned again
//                        // check if scan in same location
//                        scannedID = name
//                        self.showPopUp()
//                    }
//                }
//            }
//        } else if name == "-MaFWlwfguFE-lnLG4nZ" {
//            print("northlake location")
//            Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("locations").child(name).child("lat").observeSingleEvent(of: DataEventType.value) { latSnap in
//                Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("locations").child(name).child("long").observeSingleEvent(of: DataEventType.value) { longSnap in
//                    if let lat = latSnap as? Double, let long = longSnap as? Double {
//                        let destination = CLLocation(latitude: lat, longitude: long)
//                        let current = CLLocation(latitude: self.locationManager.location!.coordinate.latitude, longitude: self.locationManager.location!.coordinate.longitude)
//                        let distance = current.distance(from: destination) // meters
//                        let maxRadius = 200 // meters
//                        if Int(distance) > maxRadius {
//                            self.simpleAlert(title: "Error", message: "You are too far away from the destination you claim to be at.")
//                        } else {
//                            // check if scanned again
//                            // check if scan in same location
//                            scannedID = name
//                            self.showPopUp()
//                        }
//                    } else {
//                        // check if scanned again
//                        // check if scan in same location
//                        scannedID = name
//                        self.showPopUp()
//                    }
//                }
//            }
//        }
//    }
//    
//    private func cameraSetup() {
//        sceneView.delegate = self
//        sceneView.showsStatistics = true
//    }
//    
//    private func showPopUp() {
//        addSuccessNotification()
//        boardManager.backgroundViewStyle = BLTNBackgroundViewStyle.blurredDark
//        DispatchQueue.main.async {
//            self.boardManager.showBulletin(above: self)
//        }
//    }
//    
//    private func analytics() {
//        let root = Database.database().reference().child("Analytics").child("rewardsCardsScans")
//        let key = root.childByAutoId().key
//        let params : [String : Any] = [
//            "userId" : Auth.auth().currentUser?.uid ?? "newUser",
//            "restaurantId" : Restaurant.shared.restaurantId,
//            "time" : Int(Date().timeIntervalSince1970)
//        ]
//        let feed : [String : Any] = [
//            key! : params
//        ]
//        root.updateChildValues(feed)
//        print("success logging analytics")
//    }
//    
//    
//    static func completion() {
//        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(Auth.auth().currentUser!.uid).child("rewards").child(scannedID).observeSingleEvent(of: DataEventType.value) { snapshot in
//            if var value = snapshot.value as? Int {
//                let newNumber = Int(value + 1)
//                Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(Auth.auth().currentUser!.uid).child("rewards").child(scannedID).setValue(["value": newNumber, "lastScanned": "\(Int(Date().timeIntervalSince1970))"])
//                scannedID = ""
//            } else {
//                let newNumber = 1
//                Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(Auth.auth().currentUser!.uid).child("rewards").child(scannedID).setValue(["value": newNumber, "lastScanned": "\(Int(Date().timeIntervalSince1970))"])
//                scannedID = ""
//            }
//        }
//    }
//    
//    @objc func popViewController() {
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//}
