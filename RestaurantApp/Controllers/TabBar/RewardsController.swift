//
//  ScanController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/19/21.
//

import UIKit
import Firebase
import CoreLocation
import AVFoundation

var scannedID = ""

class ScanController: UIViewController, CLLocationManagerDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    var video = AVCaptureVideoPreviewLayer()
    
    var locationManager : CLLocationManager!
    
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
        
        locationServices()
        
        // Get the back-facing camera for capturing videos
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture
            captureSession.startRunning()
            
            // Initialize QR Code Frame to highlight the QR Code
            qrCodeFrameView = UIView()
            
            if let qrcodeFrameView = qrCodeFrameView {
                qrcodeFrameView.layer.borderColor = UIColor.yellow.cgColor
                qrcodeFrameView.layer.borderWidth = 2
                view.addSubview(qrcodeFrameView)
                view.bringSubviewToFront(qrcodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue anymore
            print(error)
            return
        }

        // Do any additional setup after loading the view.
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Get the metadata object
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                self.storage(withName: String(describing: metadataObj.stringValue!))
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        view.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 29).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 11).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
//        view.addSubview(cameraView)
//        cameraView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 60).isActive = true
//        cameraView.heightAnchor.constraint(equalToConstant: 285).isActive = true
//        cameraView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        cameraView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func locationServices() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if !CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func showPopUp() {
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(Auth.auth().currentUser!.uid).child("rewards").child(scannedID).child("lastScanned").observe(DataEventType.value) { snapshot in
            if let lastScanned = snapshot.value as? Int {
                let date = Date().timeIntervalSince1970
                if Int(date) - lastScanned < 600 {
                    self.simpleAlert(title: "Error", message: "Unrecognized Scan Card. Please try again later.")
                } else {
                    print("distance is \(Int(date) - lastScanned)")
                    let alert = UIAlertController(title: "QR Found!", message: "Add 1 scan to your visit?", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Add 1 Visit", style: UIAlertAction.Style.default, handler: { _ in
                        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(Auth.auth().currentUser!.uid).child("rewards").child(scannedID).child("value").observeSingleEvent(of: DataEventType.value) { snapshot in
                            if let value = snapshot.value as? Int {
                                print("existing value")
                                let newNumber = Int(value + 1)
                                Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(Auth.auth().currentUser!.uid).child("rewards").child(scannedID).setValue(["value": newNumber, "lastScanned": Int(Date().timeIntervalSince1970)])
                                scannedID = ""
                                self.analytics()
                                self.addSuccessNotification()
                                self.completion()
                            } else {
                                print("new value")
                                let newNumber = 1
                                Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(Auth.auth().currentUser!.uid).child("rewards").child(scannedID).setValue(["value": newNumber, "lastScanned": Int(Date().timeIntervalSince1970)])
                                scannedID = ""
                                self.analytics()
                                self.addSuccessNotification()
                                self.completion()
                            }
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "QR Found!", message: "Add 1 scan to your visit?", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Add 1 Visit", style: UIAlertAction.Style.default, handler: { _ in
                    Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(Auth.auth().currentUser!.uid).child("rewards").child(scannedID).child("value").observeSingleEvent(of: DataEventType.value) { snapshot in
                        if let value = snapshot.value as? Int {
                            print("existing value")
                            let newNumber = Int(value + 1)
                            Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(Auth.auth().currentUser!.uid).child("rewards").child(scannedID).setValue(["value": newNumber, "lastScanned": "\(Int(Date().timeIntervalSince1970))"])
                            scannedID = ""
                            self.analytics()
                            self.addSuccessNotification()
                            self.completion()
                        } else {
                            print("new value")
                            let newNumber = 1
                            Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(Auth.auth().currentUser!.uid).child("rewards").child(scannedID).setValue(["value": newNumber, "lastScanned": "\(Int(Date().timeIntervalSince1970))"])
                            scannedID = ""
                            self.analytics()
                            self.addSuccessNotification()
                            self.completion()
                        }
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
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
    
    func completion() {
        let alert = UIAlertController(title: "Success!", message: "1 Visit Added", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Return Home", style: UIAlertAction.Style.default, handler: { _ in
            self.moveToTabbar()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func storage(withName name: String) {
        if name == "-MnTe7uMP5msL7izwZZY" {
            Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("locations").child(name).child("lat").observeSingleEvent(of: DataEventType.value) { latSnap in
                Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("locations").child(name).child("long").observeSingleEvent(of: DataEventType.value) { longSnap in
                    if let lat = latSnap.value as? Double, let long = longSnap.value as? Double {
                        let destination = CLLocation(latitude: lat, longitude: long)
                        let current = CLLocation(latitude: self.locationManager.location!.coordinate.latitude, longitude: self.locationManager.location!.coordinate.longitude)
                        let distance = current.distance(from: destination) // meters
                        let maxRadius = 200 // meters
                        if Int(distance) > maxRadius {
                            self.addErrorNotification()
                            self.simpleAlert(title: "Error", message: "You are too far away from the destination you claim to be at.")
                        } else {
                            // check if scanned again
                            scannedID = name
                            self.showPopUp()
                        }
                    }
                }
            }
        }
    }
    
}
