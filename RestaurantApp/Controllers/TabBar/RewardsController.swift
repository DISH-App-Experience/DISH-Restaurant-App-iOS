//
//  RewardsController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/7/21.
//

import UIKit
import Firebase

class RewardsController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var locations = [Location]()
    
    var locationDatas = [RewardLocation]()
    
    var value : Int?
    
    var rewardTitleValue : String?
    
    var collectionView : UICollectionView?
    
    var currentPoints : Int? {
        didSet {
            totalScansLabel.text = "\(currentPoints!)"
            
            bigViewSingle.addSubview(rewardProgressLabel)
            let attributedMutableTitle1 = NSMutableAttributedString(string: "\(currentPoints!) of ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : Restaurant.shared.textColor])
            attributedMutableTitle1.append(NSAttributedString(string: "\(value!)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.black), NSAttributedString.Key.foregroundColor : Restaurant.shared.themeColor]))
            rewardProgressLabel.attributedText = attributedMutableTitle1
            rewardProgressLabel.topAnchor.constraint(equalTo: bigViewSingle.topAnchor, constant: 16).isActive = true
            rewardProgressLabel.rightAnchor.constraint(equalTo: bigViewSingle.rightAnchor, constant: -16).isActive = true
            rewardProgressLabel.rightAnchor.constraint(equalTo: bigViewSingle.rightAnchor, constant: -16).isActive = true
            rewardProgressLabel.heightAnchor.constraint(equalToConstant: 17).isActive = true
        }
    }
    
    var widthConstraint: NSLayoutConstraint?
    
    var widthConstraintWithValue: NSLayoutConstraint?
    
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
    
    let rewardProgress : UIView = {
        let view = UIView()
        view.backgroundColor = Restaurant.shared.themeColor
        view.layer.cornerRadius = 13.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let rewardProgressLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let multipleView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Restaurant.shared.backgroundColor
        return view
    }()
    
    let motivationMessage : UILabel = {
        let label = UILabel()
        label.text = "Keep going! You’re almost there!"
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        label.textColor = UIColor.systemGray
        label.numberOfLines = 100
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Restaurant.shared.backgroundColor
        
        widthConstraint = rewardProgress.widthAnchor.constraint(equalToConstant: CGFloat(currentPoints ?? Int(CGFloat(0))))

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateViewConstraints()
        backend()
        
        navigationController?.navigationBar.barStyle = .black
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
        
        topBanner.addSubview(totalScansLabel)
        totalScansLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 143).isActive = true
        totalScansLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        totalScansLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        totalScansLabel.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        topBanner.addSubview(scansLabel)
        scansLabel.topAnchor.constraint(equalTo: totalScansLabel.bottomAnchor, constant: 6).isActive = true
        scansLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scansLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scansLabel.heightAnchor.constraint(equalToConstant: 27).isActive = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func showScanController() {
        let controller = ScanController()
        add3DMotion(withFeedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle.medium)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func delegates() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
    
    private func backend() {
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("rewards").child("rewardValue").observe(DataEventType.value) { snapshot in
            if let value = snapshot.value as? Int {
                self.value = value
            } else {
                self.value = 10
            }
        }
        
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("rewards").child("rewardTitle").observe(DataEventType.value) { snapshot in
            if let value = snapshot.value as? String {
                self.rewardTitleValue = value
                self.rewardTitle.text = "Free \(value.uppercased())"
            } else {
                self.rewardTitle.text = "Free Reward"
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
                location.key = snapchat.key
                self.locations.append(location)
            }
            if self.locations.count > 1 {
                self.setupMultiple()
            } else {
                self.setupSingle()
            }
        }
    }
    
    private func setupMultiple() {
        locationDatas.removeAll()
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(Auth.auth().currentUser!.uid).child("rewards").observe(DataEventType.childAdded) { [self] snapshot in
            if let value = snapshot.value as? [String : Any] {
                let locationData = RewardLocation()
                locationData.lastScanned = value["lastScanned"] as? Int
                locationData.value = value["value"] as? Int
                self.locationDatas.append(locationData)
            }
            var total = 0
            for location in self.locationDatas {
                total += location.value!
            }
            print("total scans in all locations: \(total)")
            self.currentPoints = total
            collectionViewStuff()
            constraints()
            delegates()
            collectionView!.reloadData()
        }
        
        view.addSubview(multipleView)
        multipleView.topAnchor.constraint(equalTo: topBanner.bottomAnchor).isActive = true
        multipleView.leftAnchor.constraint(equalTo: topBanner.leftAnchor).isActive = true
        multipleView.rightAnchor.constraint(equalTo: topBanner.rightAnchor).isActive = true
        multipleView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.bringSubviewToFront(floatingActionButton)
    }
    
    private func collectionViewStuff() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    }
    
    private func constraints() {
        view.addSubview(collectionView!)
        collectionView?.register(RewardLocationCell.self, forCellWithReuseIdentifier: RewardLocationCell.identifier)
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.layer.masksToBounds = false
        collectionView?.alwaysBounceVertical = false
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.topAnchor.constraint(equalTo: topBanner.bottomAnchor, constant: 16).isActive = true
        collectionView?.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        collectionView?.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        
        view.bringSubviewToFront(floatingActionButton)
        
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
        
        view.addSubview(motivationMessage)
        motivationMessage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        motivationMessage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        motivationMessage.topAnchor.constraint(equalTo: bigViewSingle.bottomAnchor).isActive = true
        motivationMessage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("locations").observe(DataEventType.childAdded) { snapshot in
            let key = snapshot.key
            Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(Auth.auth().currentUser!.uid).child("rewards").child(key).child("value").observeSingleEvent(of: DataEventType.value) { snapshot in
                if let scanValue = snapshot.value as? Int {
                    self.currentPoints = scanValue
                    let lengthOfTotal : Float = Float(self.view.frame.width - 82)
                    print("length of total: \(lengthOfTotal)")
                    let distanceForOne : Float = Float(lengthOfTotal / Float(self.value!))
                    print("distance for one: \(distanceForOne)")
                    var rewardProgressLength : Float = Float(distanceForOne * Float(self.currentPoints!))
                    print("reward progress length: \(rewardProgressLength)")
                    print("reward progress length cgfloat: \(CGFloat(rewardProgressLength))")
                    
                    if self.currentPoints! >= self.value! {
                        self.motivationMessage.text = "Congrats! You have enough points to claim a \(self.rewardTitleValue!) by ordering via our app!"
                        rewardProgressLength = Float(distanceForOne) * Float(self.value!)
                    }
                    
                    self.rewardProgress.removeFromSuperview()
                    self.secondaryBackColor.addSubview(self.rewardProgress)
                    self.rewardProgress.topAnchor.constraint(equalTo: self.secondaryBackColor.topAnchor).isActive = true
                    self.rewardProgress.leftAnchor.constraint(equalTo: self.secondaryBackColor.leftAnchor).isActive = true
                    self.rewardProgress.widthAnchor.constraint(equalToConstant: CGFloat(rewardProgressLength)).isActive = true
                    self.rewardProgress.heightAnchor.constraint(equalToConstant: 27).isActive = true
                }
            }
        }
        print("done setting up single")
    }
    
    // MARK: - UICollectionView Delegate & Data Source Functions
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if locations.count == 0 {
            return 0
        } else {
            return locations.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RewardLocationCell.identifier, for: indexPath) as! RewardLocationCell
        
        cell.firstServiceView.layer.masksToBounds = false
        
        if let title = self.locations[indexPath.row].street {
            cell.firstTitle.text = title
        } else {
            cell.firstTitle.text = "Untitled Location"
        }
        
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(Auth.auth().currentUser!.uid).child("rewards").child(locations[indexPath.row].key!).child("value").observe(DataEventType.value) { rewardSnap in
            if let value = rewardSnap.value as? Int {
                cell.scanLabel.text = "\(value)"
            } else {
                cell.scanLabel.text = "0"
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("SELECTED IMAGE")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.collectionView!.frame.width / 2) - 10
        return CGSize(width: size, height: size)
    }

}
