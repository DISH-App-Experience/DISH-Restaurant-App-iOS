//
//  EventController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 12/19/21.
//

import UIKit
import Firebase
import SDWebImage

class EventController: UIViewController {
    
    var event : EventObject? {
        didSet {
            if let event = event {
                if let image = event.imageString {
                    imageView.sd_setImage(with: URL(string: image)!)
                }
                if let title = event.name {
                    titleLabel.text = title
                }
                if let desc = event.desc {
                    descriptionLabel.text = desc
                }
                if let startDate = event.date, let endDate = event.endDate {
                    let timeFormatter = DateFormatter()
                    let startFormatter = DateFormatter()
                    timeFormatter.dateFormat = "ha"
                    startFormatter.dateFormat = "MMM d, yyyy"
                    
                    let start = Date(timeIntervalSince1970: Double(startDate))
                    let end = Date(timeIntervalSince1970: Double(endDate))
                    
                    var finalString = startFormatter.string(from: start)
                    let startString = timeFormatter.string(from: start)
                    let endString = timeFormatter.string(from: end)
                    let bottomString = startString + ", " + endString
                    finalString.append("\n")
                    finalString.append(bottomString)
                    
                    priceLabel.text = finalString
                }
                if let restaurant = event.location {
                    Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("locations").child(restaurant).child("street").observeSingleEvent(of: DataEventType.value) { snapshot in
                        if let value = snapshot.value as? String {
                            self.locationLabel.text = value ?? "Our Location"
                        }
                    }
                }
            }
        }
    }
    
    let infoView : UIView = {
        let view = UIView()
        view.backgroundColor = Restaurant.shared.backgroundColor
        view.layer.cornerRadius = 50
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Restaurant.shared.themeColor
        imageView.clipsToBounds = true
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 27)
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = Restaurant.shared.themeColor
        label.textAlignment = NSTextAlignment.right
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = Restaurant.shared.themeColor
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel : UITextView = {
        let label = UITextView()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.left
        label.backgroundColor = UIColor.clear
        label.isUserInteractionEnabled = false
        label.isSelectable = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Restaurant.shared.secondaryBackground
        
        updateViewConstraints()

        // Do any additional setup after loading the view.
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        view.addSubview(infoView)
        infoView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        infoView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        infoView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        infoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 220).isActive = true
        
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: infoView.topAnchor, constant: 46).isActive = true
        view.sendSubviewToBack(imageView)
        
        infoView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 40).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 175).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 66).isActive = true
        
        infoView.addSubview(priceLabel)
        priceLabel.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 40).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        infoView.addSubview(locationLabel)
        locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        locationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        locationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        infoView.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 6).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -18).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
    }

}
