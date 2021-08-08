//
//  ReservationsCell.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 7/28/21.
//

import UIKit
import Firebase
import Foundation

class ReservationsCell: UITableViewCell {
    
    var reservation : Reservation? {
        didSet {
            if let reservation = reservation {
                if let recipient = reservation.recipient {
                    Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(recipient).child("lastName").observe(DataEventType.value) { lastNameSnap in
                        if let lastName = lastNameSnap.value as? String {
                            Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(recipient).child("firstName").observe(DataEventType.value) { firstNameSnap in
                                if let firstName = firstNameSnap.value as? String {
                                    self.itemTitleLabel.text = "\(lastName), \(firstName)"
                                }
                            }
                        }
                    }
                }
                if let status = reservation.status {
                    switch status {
                    case "accepted":
                        self.statusLabel.text = "Accepted"
                        self.statusLabel.textColor = UIColor.systemGreen
                        self.statusImage.tintColor = UIColor.systemGreen
                        self.statusImage.image = UIImage(systemName: "checkmark.seal.fill")
                    case "declined":
                        self.statusLabel.text = "Declined"
                        self.statusLabel.textColor = UIColor.systemRed
                        self.statusImage.tintColor = UIColor.systemRed
                        self.statusImage.image = UIImage(systemName: "exclamationmark.octagon.fill")
                    case "pending":
                        self.statusLabel.text = "Pending"
                        self.statusLabel.textColor = UIColor(hexString: "#F1C40F")
                        self.statusImage.tintColor = UIColor(hexString: "#F1C40F")
                        self.statusImage.image = UIImage(systemName: "questionmark.diamond.fill")
                    default:
                        print("Error finding status on reservation")
                    }
                }
                if let people = reservation.numberOfSeats {
                    self.peopleLabel.text = "\(people) Guests"
                }
                if let startTime = reservation.startTime {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                    let date = formatter.date(from: startTime)
                    
                    let firstFormatter = DateFormatter()
                    firstFormatter.dateFormat = "EEEE, MMM d, yyyy"
                    
                    let secondFormatter = DateFormatter()
                    secondFormatter.dateFormat = "h:mma"
                    
                    self.calendarLabel.text = "\(firstFormatter.string(from: date!)) at \(secondFormatter.string(from: date!))"
                }
            }
        }
    }
    
    let largeView : UIView = {
        let view = UIView()
        view.backgroundColor = Restaurant.shared.secondaryBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        return view
    }()
    
    let itemTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let statusLabel : UILabel = {
        let label = UILabel()
        label.text = "Status"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let statusImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let calendarImage : UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.darkGray
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.image = UIImage(systemName: "calendar.badge.clock")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let peopleImage : UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.darkGray
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.image = UIImage(systemName: "person.2.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let calendarLabel : UILabel = {
        let label = UILabel()
        label.text = "calendar"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let peopleLabel : UILabel = {
        let label = UILabel()
        label.text = "people"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    static let identifier = "ReservationsCellCELLID"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCell.SelectionStyle.none
        
        backgroundColor = UIColor.clear
        
        addSubview(largeView)
        largeView.topAnchor.constraint(equalTo: topAnchor, constant: 7).isActive = true
        largeView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        largeView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        largeView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7).isActive = true
        
        addSubview(itemTitleLabel)
        itemTitleLabel.topAnchor.constraint(equalTo: largeView.topAnchor, constant: 15).isActive = true
        itemTitleLabel.leftAnchor.constraint(equalTo: largeView.leftAnchor, constant: 13).isActive = true
        itemTitleLabel.rightAnchor.constraint(equalTo: largeView.rightAnchor, constant: -150).isActive = true
        itemTitleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        addSubview(statusLabel)
        statusLabel.topAnchor.constraint(equalTo: largeView.topAnchor, constant: 15).isActive = true
        statusLabel.leftAnchor.constraint(equalTo: itemTitleLabel.rightAnchor).isActive = true
        statusLabel.rightAnchor.constraint(equalTo: largeView.rightAnchor, constant: -37).isActive = true
        statusLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        addSubview(statusImage)
        statusImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        statusImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        statusImage.centerYAnchor.constraint(equalTo: statusLabel.centerYAnchor).isActive = true
        statusImage.rightAnchor.constraint(equalTo: largeView.rightAnchor, constant: -13).isActive = true
        
        addSubview(calendarImage)
        calendarImage.bottomAnchor.constraint(equalTo: largeView.bottomAnchor, constant: -13).isActive = true
        calendarImage.leftAnchor.constraint(equalTo: largeView.leftAnchor, constant: 13).isActive = true
        calendarImage.heightAnchor.constraint(equalToConstant: 18).isActive = true
        calendarImage.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        addSubview(peopleImage)
        peopleImage.bottomAnchor.constraint(equalTo: calendarImage.topAnchor, constant: -13).isActive = true
        peopleImage.leftAnchor.constraint(equalTo: largeView.leftAnchor, constant: 13).isActive = true
        peopleImage.heightAnchor.constraint(equalToConstant: 18).isActive = true
        peopleImage.widthAnchor.constraint(equalToConstant: 18).isActive = true
        
        addSubview(calendarLabel)
        calendarLabel.centerYAnchor.constraint(equalTo: calendarImage.centerYAnchor).isActive = true
        calendarLabel.leftAnchor.constraint(equalTo: calendarImage.rightAnchor, constant: 10).isActive = true
        calendarLabel.rightAnchor.constraint(equalTo: largeView.rightAnchor, constant: -13).isActive = true
        calendarLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(peopleLabel)
        peopleLabel.centerYAnchor.constraint(equalTo: peopleImage.centerYAnchor).isActive = true
        peopleLabel.leftAnchor.constraint(equalTo: peopleImage.rightAnchor, constant: 10).isActive = true
        peopleLabel.rightAnchor.constraint(equalTo: largeView.rightAnchor, constant: -13).isActive = true
        peopleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
