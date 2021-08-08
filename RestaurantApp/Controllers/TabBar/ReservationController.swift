//
//  ReservationController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/7/21.
//

import UIKit
import Firebase
import MBProgressHUD

class ReservationController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Constants

    // MARK: - Variables
    
    var reservations = [Reservation]()

    // MARK: - View Objects
    
    public var tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.clear
        tableView.register(ReservationsCell.self, forCellReuseIdentifier: ReservationsCell.identifier)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableView
    }()
    
    let floatingActionButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = Restaurant.shared.themeColor
        button.layer.cornerRadius = 28
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.white
        button.imageView?.tintColor = Restaurant.shared.textColorOnButton
        button.addTarget(self, action: #selector(createReservation), for: UIControl.Event.touchUpInside)
        button.setImage(UIImage(systemName: "plus")!, for: UIControl.State.normal)
        return button
    }()
    
    let nilView : UIView = {
        let view = UIView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nilTitle : UILabel = {
        let label = UILabel()
        label.text = "Nothing here..."
        label.textAlignment = NSTextAlignment.center
        label.textColor = Restaurant.shared.textColor
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    let nilImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Restaurant.shared.backgroundColor
        
        updateViewConstraints()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        backend()
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = Restaurant.shared.themeColor
        
        navigationItem.title = "My Reservations"
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        addNilView()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuItemCell.self, forCellReuseIdentifier: MenuItemCell.identifier)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
        
        view.addSubview(floatingActionButton)
        floatingActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
        floatingActionButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        floatingActionButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        floatingActionButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    private func backend() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.reservations.removeAll()
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("reservations").observe(DataEventType.childAdded) { snapshot in
            if let value = snapshot.value as? [String : Any] {
                let reservation = Reservation()
                reservation.userId = value["userId"] as? String
                reservation.recipient = value["recipient"] as? String
                reservation.startTime = value["startTime"] as? String
                reservation.endTime = value["endTime"] as? String
                reservation.key = snapshot.key
                reservation.numberOfSeats = value["numberOfSeats"] as? Int
                reservation.timeRequestSubmitted = value["timeRequestSubmitted"] as? Int
                reservation.status = value["status"] as? String
                if reservation.recipient! == Auth.auth().currentUser!.uid {
                    self.reservations.append(reservation)
                }
            }
            self.reservations.sort(by: {$1.timeRequestSubmitted! < $0.timeRequestSubmitted!})
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    @objc func createReservation() {
        let controller = CreateReservationController()
        add3DMotion(withFeedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle.medium)
        self.present(controller, animated: true, completion: nil)
    }
    
    private func addNilView() {
        view.addSubview(nilView)
        nilView.widthAnchor.constraint(equalToConstant: 249).isActive = true
        nilView.heightAnchor.constraint(equalToConstant: 232).isActive = true
        nilView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nilView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        nilView.addSubview(nilTitle)
        nilTitle.widthAnchor.constraint(equalTo: nilView.widthAnchor).isActive = true
        nilTitle.centerXAnchor.constraint(equalTo: nilView.centerXAnchor).isActive = true
        nilTitle.bottomAnchor.constraint(equalTo: nilView.bottomAnchor).isActive = true
        nilTitle.heightAnchor.constraint(equalToConstant: 43).isActive = true
        
        nilView.addSubview(nilImageView)
        nilImageView.topAnchor.constraint(equalTo: nilView.topAnchor).isActive = true
        nilImageView.leftAnchor.constraint(equalTo: nilView.leftAnchor).isActive = true
        nilImageView.rightAnchor.constraint(equalTo: nilView.rightAnchor).isActive = true
        nilImageView.bottomAnchor.constraint(equalTo: nilTitle.topAnchor, constant: -32).isActive = true
    }
    
    private func showNilView() {
        nilView.alpha = 1
        tableView.alpha = 0
    }
    
    private func hideNilView() {
        nilView.alpha = 0
        tableView.alpha = 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let reservations = self.reservations.count
        if reservations == 0 {
            showNilView()
        } else {
            hideNilView()
        }
        return reservations
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReservationsCell.identifier, for: indexPath) as! ReservationsCell
        cell.reservation = self.reservations[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

}
