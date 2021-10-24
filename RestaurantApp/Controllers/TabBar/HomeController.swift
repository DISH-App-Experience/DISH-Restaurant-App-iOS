//
//  HomeController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/7/21.
//

import UIKit
import Firebase
import MessageUI
import SDWebImage
import NotificationCenter

class HomeController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    var menutItems = [MenuItem]()
    
    // ADD RESTAURANT WEBSITEBELOW TO ADD ACCESS
    let websiteURL = ""
    
    var actions = [HomeAction]() {
        didSet {
            actionCollectionView.reloadData()
        }
    }
    
    var infoActions = [InfoAction]() {
        didSet {
            infoTableView.reloadData()
        }
    }
    
    let statusBarView : UIView = {
        let view = UIView()
        view.backgroundColor = Restaurant.shared.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    let welcomeLabel : UILabel = {
        let label = UILabel()
        label.text = "Hi there!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    let profileImage : UIButton = {
        let button = UIButton()
        button.backgroundColor = Restaurant.shared.backgroundColor
        button.clipsToBounds = false
        button.setImage(UIImage(systemName: "person.crop.circle"), for: UIControl.State.normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.tintColor = Restaurant.shared.themeColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(profileImagePressed), for: UIControl.Event.touchUpInside)
        button.layer.cornerRadius = 17.5
        return button
    }()
    
    let alertView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Restaurant.shared.themeColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    let alertImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 22.5
        imageView.clipsToBounds = true
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    let alertLabel : UILabel = {
        let label = UILabel()
        label.text = "Hi there!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = Restaurant.shared.textColorOnButton
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    let alertDescription : UILabel = {
        let label = UILabel()
        label.text = "Hi there!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Restaurant.shared.textColorOnButton
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    let menuTitle : UILabel = {
        let label = UILabel()
        label.text = "Top Menu Items"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    let viewMenuButton : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("View Menu", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(Restaurant.shared.themeColor, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(menuButtonPressed), for: UIControl.Event.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    var menuCollectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HomeMenuCell.self, forCellWithReuseIdentifier: HomeMenuCell.identifier)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = false
        return collectionView
    }()
    
    let actionTitle : UILabel = {
        let label = UILabel()
        label.text = "Quick Actions"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    var actionCollectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HomeActionCell.self, forCellWithReuseIdentifier: HomeActionCell.identifier)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = false
        return collectionView
    }()
    
    let infoTitle : UILabel = {
        let label = UILabel()
        label.text = "App Info"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    let infoTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HomeInfoCell.self, forCellReuseIdentifier: HomeInfoCell.identifier)
        tableView.backgroundColor = UIColor.clear
        return tableView
    }()
    
    let fab : MainFAB = {
        let fab = MainFAB()
        fab.setImage(UIImage(systemName: "cart.fill"), for: UIControl.State.normal)
        fab.addTarget(self, action: #selector(moveToOrder), for: UIControl.Event.touchUpInside)
        return fab
    }()
    
    let dishImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.image = UIImage(named: "lightDISH")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let notification = UILocalNotification()
//        notification.alertTitle = "Happy Birthday!"
//        notification.alertBody = "This is your daily notification."
//        notification.timeZone = NSTimeZone.local
//        notification.fireDate = Date().addingTimeInterval(1800)
//        notification.repeatInterval = .day
//        UIApplication.shared.scheduleLocalNotification(notification)
        
        view.backgroundColor = Restaurant.shared.backgroundColor
        
        updateViewConstraints()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = Restaurant.shared.themeColor
        navigationController?.navigationBar.isHidden = true
        
        backend()
        setupActions()
        setupInfoActions()
        notification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 950)
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        scrollView.addSubview(welcomeLabel)
        welcomeLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50).isActive = true
        welcomeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        welcomeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        scrollView.addSubview(profileImage)
        profileImage.topAnchor.constraint(equalTo: welcomeLabel.topAnchor).isActive = true
        profileImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 35).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        scrollView.addSubview(alertView)
        alertView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 39).isActive = true
        alertView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        alertView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        alertView.heightAnchor.constraint(equalToConstant: 66).isActive = true
        
        alertView.addSubview(alertImage)
        alertImage.topAnchor.constraint(equalTo: alertView.topAnchor, constant: -11).isActive = true
        alertImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -11).isActive = true
        alertImage.heightAnchor.constraint(equalToConstant: 45).isActive = true
        alertImage.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        alertView.addSubview(alertLabel)
        alertLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 12).isActive = true
        alertLabel.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 18).isActive = true
        alertLabel.rightAnchor.constraint(equalTo: alertImage.leftAnchor, constant: -5).isActive = true
        alertLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        alertView.addSubview(alertDescription)
        alertDescription.topAnchor.constraint(equalTo: alertLabel.bottomAnchor).isActive = true
        alertDescription.leftAnchor.constraint(equalTo: alertLabel.leftAnchor).isActive = true
        alertDescription.rightAnchor.constraint(equalTo: alertLabel.rightAnchor).isActive = true
        alertDescription.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        scrollView.addSubview(menuTitle)
        menuTitle.topAnchor.constraint(equalTo: alertView.bottomAnchor, constant: 30).isActive = true
        menuTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        menuTitle.widthAnchor.constraint(equalToConstant: 130).isActive = true
        menuTitle.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        scrollView.addSubview(viewMenuButton)
        viewMenuButton.topAnchor.constraint(equalTo: alertView.bottomAnchor, constant: 30).isActive = true
        viewMenuButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        viewMenuButton.widthAnchor.constraint(equalToConstant: 77).isActive = true
        viewMenuButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        let menuLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        menuLayout.scrollDirection = .horizontal
        
        scrollView.addSubview(menuCollectionView)
        menuCollectionView.delegate = self
        menuCollectionView.collectionViewLayout = menuLayout
        menuCollectionView.dataSource = self
        menuCollectionView.topAnchor.constraint(equalTo: viewMenuButton.bottomAnchor, constant: 20).isActive = true
        menuCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        menuCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        menuCollectionView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        scrollView.addSubview(actionTitle)
        actionTitle.topAnchor.constraint(equalTo: menuCollectionView.bottomAnchor, constant: 36).isActive = true
        actionTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        actionTitle.widthAnchor.constraint(equalToConstant: 130).isActive = true
        actionTitle.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        let actionLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        actionLayout.scrollDirection = .horizontal
        
        scrollView.addSubview(actionCollectionView)
        actionCollectionView.delegate = self
        actionCollectionView.dataSource = self
        actionCollectionView.collectionViewLayout = actionLayout
        actionCollectionView.topAnchor.constraint(equalTo: actionTitle.bottomAnchor, constant: 20).isActive = true
        actionCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        actionCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        actionCollectionView.heightAnchor.constraint(equalToConstant: 88).isActive = true
        
        scrollView.addSubview(infoTitle)
        infoTitle.topAnchor.constraint(equalTo: actionCollectionView.bottomAnchor, constant: 36).isActive = true
        infoTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        infoTitle.widthAnchor.constraint(equalToConstant: 130).isActive = true
        infoTitle.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        scrollView.addSubview(infoTableView)
        infoTableView.delegate = self
        infoTableView.dataSource = self
        infoTableView.topAnchor.constraint(equalTo: infoTitle.bottomAnchor, constant: 15).isActive = true
        infoTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        infoTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        infoTableView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        dishImage.isUserInteractionEnabled = true
        dishImage.addGestureRecognizer(tapGestureRecognizer)
        
        scrollView.addSubview(dishImage)
        dishImage.topAnchor.constraint(equalTo: infoTableView.bottomAnchor, constant: 15).isActive = true
        dishImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dishImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        dishImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(statusBarView)
        statusBarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        statusBarView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        statusBarView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        statusBarView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("rewards").child("allowCheckoutWithScanOnly").observe(DataEventType.value) { snap in
            if let value = snap.value as? Bool {
                if value {
                    self.view.addSubview(self.fab)
                    self.fab.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
                    self.fab.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
                    self.fab.widthAnchor.constraint(equalToConstant: 56).isActive = true
                    self.fab.heightAnchor.constraint(equalToConstant: 56).isActive = true
                }
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.menuCollectionView {
            return self.menutItems.count
        } else {
            return self.actions.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.menuCollectionView {
            let cell = menuCollectionView.dequeueReusableCell(withReuseIdentifier: HomeMenuCell.identifier, for: indexPath) as! HomeMenuCell
            cell.menuItem = self.menutItems[indexPath.row]
            cell.backgroundColor = UIColor.clear
            return cell
        } else {
            let cell = actionCollectionView.dequeueReusableCell(withReuseIdentifier: HomeActionCell.identifier, for: indexPath) as! HomeActionCell
            cell.action = self.actions[indexPath.row]
            cell.backgroundColor = UIColor.clear
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.menuCollectionView {
            showMenuItem(menuItem: self.menutItems[indexPath.row])
        } else {
            switch self.actions[indexPath.row].title! {
            case "Call Us":
                callUs()
            case "About Us":
                popAboutUsController()
            case "Locations":
                pushToController(viewController: LocationsController())
            case "Gallery":
                pushToController(viewController: GalleryController())
            default:
                print("other")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.menuCollectionView {
            return CGSize(width: 128, height: 130)
        } else if collectionView == self.actionCollectionView {
            return CGSize(width: 159, height: 88)
        } else {
            return CGSize(width: 10, height: 10)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoActions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = infoTableView.dequeueReusableCell(withIdentifier: HomeInfoCell.identifier, for: indexPath) as! HomeInfoCell
        cell.action = self.infoActions[indexPath.row]
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.infoActions[indexPath.row].title! {
        case "Rate Us":
            // ADD APP ID AFTER THE FORWARD SLASH ON THE URL BELOW TO CONNECT TO RATINGS!!
            if let url = URL(string: "itms-apps://itunes.apple.com/app/") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case "Our Website":
            // ADD RESTAURANT WEBSITE TS AND CS BELOW TO ADD ACCESS
            let websiteURL = ""
            if let url = URL(string: websiteURL), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        case "About Us":
            popAboutUsController()
        case "Contact Us":
            openMail()
        default:
            print("other")
        }
    }
    
    private func backend() {
        let id = Restaurant.shared.restaurantId
        Database.database().reference().child("Apps").child(id).child("Users").child(Auth.auth().currentUser!.uid).child("firstName").observe(DataEventType.value) { snapshot in
            if let value = snapshot.value as? String {
                self.welcomeLabel.text = "Hi, " + value + "!"
            } else {
                self.welcomeLabel.text = "Hi there!"
            }
        }
        
//        Database.database().reference().child("Apps").child(id).child("Users").child(Auth.auth().currentUser!.uid).child("gender").observe(DataEventType.value) { snapshot in
//            if let value = snapshot.value as? String {
//                if value != "Male" {
//                    self.profileImage.setImage(UIImage(named: "femaleuser"), for: UIControl.State.normal)
//                } else {
//                    self.profileImage.setImage(UIImage(named: "maleuser"), for: UIControl.State.normal)
//                }
//            } else {
//                self.profileImage.setImage(UIImage(named: "maleuser"), for: UIControl.State.normal)
//            }
//        }
        
        alertImage.sd_setImage(with: URL(string: Restaurant.shared.logo)!, completed: nil)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let weekday = formatter.string(from: Date())
        alertLabel.text = "Happy \(weekday)!"
        
        switch weekday {
            case "Monday":
                alertDescription.text = "How about starting the week with \(Restaurant.shared.name)?"
            case "Tuesday":
                alertDescription.text = "It's only Tuesday?! Speed up with a delicous meal!"
            case "Wednesday":
                alertDescription.text = "You're halfway through the week!"
            case "Thursday":
                alertDescription.text = "One day 'til Friday! Aren't you excited?"
            case "Friday":
                alertDescription.text = "TGIF!! You're made it through the week!"
            case "Saturday":
                alertDescription.text = "Weekend treat at \(Restaurant.shared.name)?"
            case "Sunday":
                alertDescription.text = "Enjoy the last bits of the weekend at \(Restaurant.shared.name)"
            default:
                alertDescription.text = "If you want a rainbow, you'll have to put up with the rain! Keep going!!"
        }
        
        print("resarch")
        self.menutItems.removeAll()
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("menu").child("items").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let item = MenuItem()
                item.title = value["title"] as? String
                item.desc = value["description"] as? String
                item.price = value["price"] as? Double
                item.imageUrl = value["image"] as? String
                item.timestamp = value["time"] as? Int
                self.menutItems.append(item)
            }
            self.menutItems.sort(by: { $1.timestamp! < $0.timestamp! } )
            self.menuCollectionView.reloadData()
        }
    }
    
    private func setupInfoActions() {
        infoActions.removeAll()
        
        let rateUs = InfoAction()
        rateUs.title = "Rate Us"
        rateUs.image = UIImage(systemName: "star.fill")!
        
        let terms = InfoAction()
        terms.title = "Our Website"
        terms.image = UIImage(systemName: "bookmark.fill")!
        
        let aboutUs = InfoAction()
        aboutUs.title = "About Us"
        aboutUs.image = UIImage(systemName: "info.circle.fill")!
        
        let contactUs = InfoAction()
        contactUs.title = "Contact Us"
        contactUs.image = UIImage(systemName: "envelope.fill")!
        
        infoActions.append(rateUs)
        infoActions.append(terms)
        infoActions.append(aboutUs)
        infoActions.append(contactUs)
    }
    
    private func setupActions() {
        self.actions.removeAll()
        
        let callUs = HomeAction()
        callUs.title = "Call Us"
        callUs.image = UIImage(systemName: "phone.fill")!
        
        let locations = HomeAction()
        locations.title = "Locations"
        locations.image = UIImage(systemName: "location.fill")!
        
        let aboutUs = HomeAction()
        aboutUs.title = "About Us"
        aboutUs.image = UIImage(systemName: "info")!
        
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("features").child("imageGallery").observe(DataEventType.value) { snapshot in
            if let value = snapshot.value as? Bool {
                if value {
                    let gallery = HomeAction()
                    gallery.title = "Gallery"
                    gallery.image = UIImage(systemName: "camera.fill")!
                    
                    self.actions.append(callUs)
                    self.actions.append(locations)
                    self.actions.append(aboutUs)
                    self.actions.append(gallery)
                } else {
                    self.actions.append(callUs)
                    self.actions.append(locations)
                    self.actions.append(aboutUs)
                }
            }
        }
    }
    
    private func analytics() {
        let root = Database.database().reference().child("Analytics").child("callFromHome")
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
    
    private func callUs() {
        analytics()
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("about").child("phoneNumber").observe(DataEventType.value) { snapshot in
            if let value = snapshot.value as? String {
                if let url = URL(string: "tel://\(value)") {
                  UIApplication.shared.open(url)
                }
            }
        }
    }
    
    private func openMail() {
        guard MFMailComposeViewController.canSendMail() else {
            simpleAlert(title: "Error", message: "Cannot send mail. Please download the Apple Mail App!")
            return
        }
        let email = "jorgejaden@gmail.com"
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients([email])
        self.present(composer, animated: true)
    }
    
    private func notification() {
        
        // Notification Implementation
        let pushManager = PushNotificationManager(userID: Auth.auth().currentUser!.uid)
        pushManager.registerForPushNotifications()
    }
    
    @objc func profileImagePressed() {
        moveToProfileController()
    }
    
    @objc func menuButtonPressed() {
        moveToMenuPage()
    }
    
    @objc func moveToOrder() {
        let controller = SelectLocationOrder()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        add3DMotion(withFeedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle.medium)
        if let url = URL(string: "https://dish-digital.netlify.app") {
            UIApplication.shared.open(url)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            if let _ = error {
                controller.dismiss(animated: true, completion: nil)
                return
            }
            switch result {
            case .cancelled:
                break
            case .failed:
                break
            case .saved:
                break
            case .sent:
                break
            default:
                break
            }
            controller.dismiss(animated: true, completion: nil)
        }

}
