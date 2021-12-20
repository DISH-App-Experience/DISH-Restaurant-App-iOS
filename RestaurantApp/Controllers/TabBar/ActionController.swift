//
//  ActionController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/7/21.
//

import UIKit
import Firebase
import EventKit
import MBProgressHUD

class ActionController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Constants
    
    let eventStore : EKEventStore = EKEventStore()
    
    // MARK: - Variables
    
    var features = [String]()
    
    var control : UISegmentedControl?
    
    var eventsList = [EventObject]()
    
    var promosList = [Promotion]()
    
    var selectedEvent : EventObject?
    
    // MARK: - View Objects
    
    let eventView : UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = Restaurant.shared.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let promoView : UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = Restaurant.shared.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let eventsTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clear
        tableView.register(EventsCell.self, forCellReuseIdentifier: EventsCell.identifier)
        return tableView
    }()
    
    let promosTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clear
        tableView.register(PromosCell.self, forCellReuseIdentifier: PromosCell.identifier)
        return tableView
    }()
    
    let eventNilView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let promoNilView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let eventNilImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "tray")
        imageView.tintColor = Restaurant.shared.themeColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    let eventNilTitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Restaurant.shared.textColor
        label.text = "No Events Yet!"
        label.numberOfLines = 3
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    let promoNilImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "questionmark.folder")
        imageView.tintColor = Restaurant.shared.themeColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    let promoNilTitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Restaurant.shared.textColor
        label.text = "No Promos Yet!"
        label.numberOfLines = 3
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    var blurView : UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.systemMaterial))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.alpha = 0
        return blurView
    }()
    
    let blurButtonPromo : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(hidePromotionBlurView), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    private let bigView : UIView = {
        let view = UIView()
        view.backgroundColor = Restaurant.shared.backgroundColor
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    private let dateHolderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Restaurant.shared.textColor
        label.text = "Valid Until:"
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    private let timeHolderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Restaurant.shared.textColor
        label.text = "Use Code:"
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    private let seatsHolderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Restaurant.shared.textColor
        label.text = "Description:"
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    private let timeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    private let seatsLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 2
        return label
    }()
    
    private let eventImage : MainImageView = {
        let imageView = MainImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let eventButton : MainButton = {
        let button = MainButton()
        button.setTitle("Add to Apple Calendar", for: UIControl.State.normal)
        button.backgroundColor = Restaurant.shared.themeColor
        button.addTarget(self, action: #selector(addToCalendar), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    // MARK: - Overriden Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.backgroundColor = Restaurant.shared.backgroundColor
        
        setupPromotionBlurView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        backend()
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = Restaurant.shared.themeColor
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode.always
        
        navigationItem.backButtonTitle = "Back"
        navigationItem.title = "Action"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        control?.removeFromSuperview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hidePromotionBlurView()
    }
    
    // MARK: - Private Functions
    
    private func backend() {
        MBProgressHUD.showAdded(to: view, animated: true)
        checkFeatures()
    }
    
    private func checkFeatures() {
        // check for events
        features.removeAll()
        events()
    }
    
    private func events() {
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("features").child("newsEvents").observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? Bool {
                if value {
                    self.features.append("Events")
                    self.checkEvents()
                    // check for promos
                    self.promos()
                } else {
                    // check for promos
                    self.promos()
                }
            }
        }
    }
    
    private func promos() {
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("features").child("sendPromos").observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? Bool {
                if value {
                    self.features.append("Promos")
                    self.checkPromos()
                    self.createSegmentedControl(withItems: self.features)
                } else {
                    self.createSegmentedControl(withItems: self.features)
                }
            }
        }
    }
    
    private func createSegmentedControl(withItems items: [String]) {
        control = UISegmentedControl(items: items)
        control!.translatesAutoresizingMaskIntoConstraints = false
        control!.backgroundColor = Restaurant.shared.secondaryBackground
        control!.selectedSegmentIndex = 0
        control!.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : Restaurant.shared.textColorOnButton], for: UIControl.State.selected)
        control!.selectedSegmentTintColor = Restaurant.shared.themeColor
        control!.addTarget(self, action: #selector(segmentControlTapped(_:)), for: .valueChanged)
        
        // constraints
        view.addSubview(control!)
        control!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        control!.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        control!.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        control!.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        setupEventView()
        setupPromoView()
        
        showView(withName: features[0])
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    private func showView(withName name: String) {
        switch name {
        case "Events":
            prioritizeView(view: eventView, hideView1: promoView)
        case "Promos":
            prioritizeView(view: promoView, hideView1: eventView)
        default:
            print("undecided view")
        }
    }
    
    private func setupEventView() {
        view.addSubview(eventView)
        eventView.topAnchor.constraint(equalTo: control!.bottomAnchor, constant: 15).isActive = true
        eventView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        eventView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        eventView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        
        eventView.addSubview(eventNilView)
        eventNilView.widthAnchor.constraint(equalToConstant: 249).isActive = true
        eventNilView.heightAnchor.constraint(equalToConstant: 232).isActive = true
        eventNilView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        eventNilView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        eventNilView.addSubview(eventNilImageView)
        eventNilImageView.topAnchor.constraint(equalTo: eventNilView.topAnchor).isActive = true
        eventNilImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        eventNilImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        eventNilImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        eventNilView.addSubview(eventNilTitleLabel)
        eventNilTitleLabel.topAnchor.constraint(equalTo: eventNilImageView.bottomAnchor).isActive = true
        eventNilTitleLabel.leftAnchor.constraint(equalTo: eventNilView.leftAnchor).isActive = true
        eventNilTitleLabel.rightAnchor.constraint(equalTo: eventNilView.rightAnchor).isActive = true
        eventNilTitleLabel.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        eventView.addSubview(eventsTableView)
        eventsTableView.delegate = self
        eventsTableView.backgroundColor = Restaurant.shared.backgroundColor
        eventsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        eventsTableView.dataSource = self
        eventsTableView.topAnchor.constraint(equalTo: eventView.topAnchor).isActive = true
        eventsTableView.bottomAnchor.constraint(equalTo: eventView.bottomAnchor).isActive = true
        eventsTableView.leftAnchor.constraint(equalTo: eventView.leftAnchor).isActive = true
        eventsTableView.rightAnchor.constraint(equalTo: eventView.rightAnchor).isActive = true
    }
    
    private func setupPromoView() {
        view.addSubview(promoView)
        promoView.topAnchor.constraint(equalTo: control!.bottomAnchor, constant: 15).isActive = true
        promoView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        promoView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        promoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        
        promoView.addSubview(promoNilView)
        promoNilView.widthAnchor.constraint(equalToConstant: 249).isActive = true
        promoNilView.heightAnchor.constraint(equalToConstant: 232).isActive = true
        promoNilView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        promoNilView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        promoNilView.addSubview(promoNilImageView)
        promoNilImageView.topAnchor.constraint(equalTo: promoNilView.topAnchor).isActive = true
        promoNilImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        promoNilImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        promoNilImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        promoNilView.addSubview(promoNilTitleLabel)
        promoNilTitleLabel.topAnchor.constraint(equalTo: promoNilImageView.bottomAnchor).isActive = true
        promoNilTitleLabel.leftAnchor.constraint(equalTo: promoNilView.leftAnchor).isActive = true
        promoNilTitleLabel.rightAnchor.constraint(equalTo: promoNilView.rightAnchor).isActive = true
        promoNilTitleLabel.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        promoView.addSubview(promosTableView)
        promosTableView.delegate = self
        promosTableView.backgroundColor = Restaurant.shared.backgroundColor
        promosTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        promosTableView.dataSource = self
        promosTableView.topAnchor.constraint(equalTo: promoView.topAnchor).isActive = true
        promosTableView.bottomAnchor.constraint(equalTo: promoView.bottomAnchor).isActive = true
        promosTableView.leftAnchor.constraint(equalTo: promoView.leftAnchor).isActive = true
        promosTableView.rightAnchor.constraint(equalTo: promoView.rightAnchor).isActive = true
    }
    
    private func prioritizeView(view: UIView, hideView1: UIView) {
        view.alpha = 1
        self.view.bringSubviewToFront(view)
        
        hideView1.alpha = 0
        self.view.sendSubviewToBack(hideView1)
    }
    
    private func checkEvents() {
        eventsList.removeAll()
        let production = Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("events")
        production.observe(DataEventType.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let event = EventObject()
                event.name = value["name"] as? String
                event.desc = value["desc"] as? String
                event.date = value["date"] as? Int
                event.endDate = value["endDate"] as? Int
                event.location = value["location"] as? String
                event.imageString = value["imageString"] as? String
                event.key = value["key"] as? String ?? snapshot.key
                self.eventsList.append(event)
            }
            print("there are \(self.eventsList.count) events")
            let newArr = self.eventsList.sorted(by: { $1.date! < $0.date! } )
            self.eventsList.removeAll()
            self.eventsList = newArr
            self.eventsTableView.reloadData()
        }
    }
    
    private func checkPromos() {
        promosList.removeAll()
        let production = Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("promotions")
        production.observe(DataEventType.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let promo = Promotion()
                promo.name = value["name"] as? String
                promo.desc = value["desc"] as? String
                promo.date = value["date"] as? Int
                promo.code = value["code"] as? String ?? "NONE"
                promo.validUntil = value["validUntil"] as? Int
                promo.key = value["key"] as? String ?? snapshot.key
                self.promosList.append(promo)
            }
            print("there are \(self.promosList.count) promotions")
            let newArr = self.promosList.sorted(by: { $1.validUntil! < $0.validUntil! } )
            self.promosList.removeAll()
            self.promosList = newArr
            self.promosTableView.reloadData()
        }
    }
    
    private func hideNilEvent() {
        print("hiding nil view for events")
        UIView.animate(withDuration: 0.5) {
            self.eventsTableView.alpha = 1
        }
    }
    
    private func showNilEvent() {
        print("show nil view for events")
        UIView.animate(withDuration: 0.5) {
            self.eventsTableView.alpha = 0
        }
    }
    
    private func hideNilPromo() {
        print("hiding nil view for promos")
        UIView.animate(withDuration: 0.5) {
            self.promosTableView.alpha = 1
        }
    }
    
    private func showNilPromo() {
        print("showing nil view for promos")
        UIView.animate(withDuration: 0.5) {
            self.promosTableView.alpha = 0
        }
    }
    
    private func setupPromotionBlurView() {
        view.addSubview(blurView)
        blurView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.view.sendSubviewToBack(blurView)
        
        blurView.contentView.addSubview(blurButtonPromo)
        blurButtonPromo.topAnchor.constraint(equalTo: blurView.topAnchor).isActive = true
        blurButtonPromo.leftAnchor.constraint(equalTo: blurView.leftAnchor).isActive = true
        blurButtonPromo.rightAnchor.constraint(equalTo: blurView.rightAnchor).isActive = true
        blurButtonPromo.bottomAnchor.constraint(equalTo: blurView.bottomAnchor).isActive = true
        
        blurView.contentView.addSubview(bigView)
        bigView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bigView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        bigView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 110).isActive = true
        bigView.heightAnchor.constraint(equalToConstant: view.frame.size.height - 600).isActive = true
        
        bigView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: bigView.topAnchor, constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: bigView.rightAnchor, constant: -16).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        bigView.addSubview(dateHolderLabel)
        dateHolderLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        dateHolderLabel.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 16).isActive = true
        dateHolderLabel.rightAnchor.constraint(equalTo: bigView.rightAnchor, constant: -16).isActive = true
        dateHolderLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        bigView.addSubview(timeHolderLabel)
        timeHolderLabel.topAnchor.constraint(equalTo: dateHolderLabel.bottomAnchor).isActive = true
        timeHolderLabel.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 16).isActive = true
        timeHolderLabel.rightAnchor.constraint(equalTo: bigView.rightAnchor, constant: -16).isActive = true
        timeHolderLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        bigView.addSubview(seatsHolderLabel)
        seatsHolderLabel.topAnchor.constraint(equalTo: timeHolderLabel.bottomAnchor).isActive = true
        seatsHolderLabel.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 16).isActive = true
        seatsHolderLabel.rightAnchor.constraint(equalTo: bigView.rightAnchor, constant: -16).isActive = true
        seatsHolderLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        bigView.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 16).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: bigView.rightAnchor, constant: -16).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        bigView.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: dateHolderLabel.bottomAnchor).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 16).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: bigView.rightAnchor, constant: -16).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        bigView.addSubview(seatsLabel)
        seatsLabel.topAnchor.constraint(equalTo: seatsHolderLabel.bottomAnchor).isActive = true
        seatsLabel.leftAnchor.constraint(equalTo: bigView.leftAnchor, constant: 16).isActive = true
        seatsLabel.rightAnchor.constraint(equalTo: bigView.rightAnchor, constant: -16).isActive = true
        seatsLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        bigView.addSubview(eventImage)
        eventImage.bottomAnchor.constraint(equalTo: bigView.topAnchor, constant: 10).isActive = true
        eventImage.centerXAnchor.constraint(equalTo: bigView.centerXAnchor).isActive = true
        eventImage.heightAnchor.constraint(equalToConstant: 120).isActive = true
        eventImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    private func showPromotionBlurView() {
        view.bringSubviewToFront(blurView)
        UIView.animate(withDuration: 0.4) {
            self.blurView.alpha = 1
            self.eventButton.alpha = 1
        }
    }
    
    private func clearPromoView() {
        dateLabel.text = ""
        timeLabel.text = ""
        seatsLabel.text = ""
        titleLabel.text = ""
    }
    
    // MARK: - Objective-C Functions
    
    @objc func segmentControlTapped(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            showView(withName: features[0])
            print("selected 0: \(features[segmentedControl.selectedSegmentIndex])")
        case 1:
            showView(withName: features[1])
            print("selected 1: \(features[segmentedControl.selectedSegmentIndex])")
        default:
            print("selected default")
        }
    }
    
    @objc func hidePromotionBlurView() {
        UIView.animate(withDuration: 0.4) {
            self.blurView.alpha = 0
            self.eventButton.alpha = 0
        } completion: { completion in
            if completion {
                self.clearPromoView()
                self.view.sendSubviewToBack(self.blurView)
            }
        }
    }
    
    @objc func addToCalendar() {
        if let selected = selectedEvent {
            eventStore.requestAccess(to: EKEntityType.event) { granted, error in
                if granted && error == nil {
                    let event : EKEvent = EKEvent(eventStore: self.eventStore)
                    event.startDate = Date(timeIntervalSince1970: Double(selected.date!))
                    event.endDate = Date(timeIntervalSince1970: Double(selected.endDate!))
                    event.notes = selected.desc
                    event.title = selected.name
                    event.calendar = self.eventStore.defaultCalendarForNewEvents
                    do {
                        try self.eventStore.save(event, span: .thisEvent)
                    } catch let error as NSError {
                        self.simpleAlert(title: "Error, failed to save event", message: error.localizedDescription)
                    }
                    DispatchQueue.main.async {
                        print("success")
                        self.simpleAlert(title: "Success", message: "Added event to Apple Calendar")
                    }
                } else {
                    print("failed to save event with error : \(error!.localizedDescription) or access not granted")
                }
            }
        }
    }
    
    // MARK: - UITableView Delegation
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case eventsTableView:
            if eventsList.count == 0 {
                showNilEvent()
            } else {
                hideNilEvent()
            }
            return eventsList.count
        case promosTableView:
            if promosList.count == 0 {
                showNilPromo()
            } else {
                hideNilPromo()
            }
            return promosList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case eventsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: EventsCell.identifier, for: indexPath) as! EventsCell
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.backgroundColor = Restaurant.shared.backgroundColor
            
            if let imageString = self.eventsList[indexPath.row].imageString {
                cell.itemImageView.loadImageUsingUrlString(urlString: imageString)
            }
            
            if let title = self.eventsList[indexPath.row].name {
                cell.itemTitleLabel.text = title
            }
            
            if let desc = self.eventsList[indexPath.row].desc {
                cell.itemDescLabel.text = desc
            }
            
            if let date = self.eventsList[indexPath.row].date {
                let formatter = DateFormatter()
                formatter.dateFormat = "E, d MMMM yyyy"
                cell.itemCatLabel.text = "\(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(date))))"
            }
            
            return cell
        case promosTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: PromosCell.identifier, for: indexPath) as! PromosCell
            
            if let title = self.promosList[indexPath.row].name {
                cell.itemTitleLabel.text = title
            }
            
            if let validUntil = self.promosList[indexPath.row].validUntil, let code = self.promosList[indexPath.row].code {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM d, yyyy"
                let expirationDate = Date(timeIntervalSince1970: TimeInterval(validUntil))
                if code == "NONE" || code == "" {
                    cell.itemDescLabel.text = "VALID UNTIL: \(formatter.string(from: expirationDate))"
                } else {
                    cell.itemDescLabel.text = "VALID UNTIL: \(formatter.string(from: expirationDate)) - Use Code: \(code)."
                }
            }
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "other", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case eventsTableView:
            return 110
        case promosTableView:
            return 85
        default:
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case eventsTableView:
            selectedEvent = self.eventsList[indexPath.row]
            
            let controller = EventController()
            controller.event = selectedEvent
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone) {
                self.present(controller, animated: true, completion: nil)
            } else {
                var popoverCntlr = UIPopoverController(contentViewController: controller)
                popoverCntlr.present(from: CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0),  in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
            }
            
//            let formatter = DateFormatter()
//            formatter.dateFormat = "E, MMM d @ h:mma"
//
//            self.dateHolderLabel.text = "Date:"
//            self.timeHolderLabel.text = "Location:"
//            self.seatsHolderLabel.text = "Description:"
//
//            self.titleLabel.text = self.eventsList[indexPath.row].name ?? "Event"
//            self.dateLabel.text = "\(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(self.eventsList[indexPath.row].date!))))"
//            self.seatsLabel.text = self.eventsList[indexPath.row].desc!
//
//            Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("locations").child(self.eventsList[indexPath.row].location!).child("street").observe(DataEventType.value) { snapshot in
//                if let streetString = snapshot.value as? String {
//                    self.timeLabel.text = streetString
//                }
//            }
//
//            self.eventImage.loadImage(from: URL(string: self.eventsList[indexPath.row].imageString!)!)
//
//            self.eventImage.alpha = 1
//
//            blurView.contentView.addSubview(eventButton)
//            eventButton.topAnchor.constraint(equalTo: bigView.bottomAnchor, constant: 16).isActive = true
//            eventButton.leftAnchor.constraint(equalTo: bigView.leftAnchor).isActive = true
//            eventButton.rightAnchor.constraint(equalTo: bigView.rightAnchor).isActive = true
//            eventButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
//
//            showPromotionBlurView()
        case promosTableView:
            let formatter = DateFormatter()
            formatter.dateFormat = "E, MMM d yyyy"
            
            self.eventImage.alpha = 0
            self.eventImage.image = nil
            
            self.dateHolderLabel.text = "Valid Until:"
            self.timeHolderLabel.text = "Use Code:"
            self.seatsHolderLabel.text = "Description:"
            
            self.titleLabel.text = self.promosList[indexPath.row].name ?? "Promotion"
            self.dateLabel.text = "\(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(self.promosList[indexPath.row].validUntil!))))"
            self.timeLabel.text = self.promosList[indexPath.row].code!
            self.seatsLabel.text = self.promosList[indexPath.row].desc!
            
            eventButton.removeFromSuperview()
            
            showPromotionBlurView()
        default:
            print("extra item selected")
        }
    }
    
}
