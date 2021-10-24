//
//  RewardLocationCell.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 8/10/21.
//

import UIKit
import MapKit
import Foundation

class RewardLocationCell: UICollectionViewCell {
    
    static let identifier = "rewardLocationCell12"
    
    let mapView : MKMapView = {
        let mapView = MKMapView()
        mapView.isScrollEnabled = false
        mapView.isUserInteractionEnabled = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let scanLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 45)
        label.textColor = Restaurant.shared.themeColor
        label.text = "3"
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    let scanScansLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = Restaurant.shared.textColor
        label.text = "Scans"
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    let firstServiceView : UIView = {
        let view = UIView()
        view.backgroundColor = Restaurant.shared.backgroundColor
        view.layer.cornerRadius = 25
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 50
        view.layer.shadowOpacity = 0.05
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let firstServiceImage : MainImageView = {
        let imageView = MainImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.purple
        return imageView
    }()
    
    let firstTitle : UILabel = {
        let label = UILabel()
        label.textColor = Restaurant.shared.textColor
        label.font = UIFont.italicSystemFont(ofSize: 10)
        label.text = "Title"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        addSubview(firstServiceView)
        firstServiceView.layer.masksToBounds = false
        firstServiceView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        firstServiceView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        firstServiceView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        firstServiceView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
        firstServiceView.addSubview(firstTitle)
        firstTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        firstTitle.leftAnchor.constraint(equalTo: firstServiceView.leftAnchor, constant: 12).isActive = true
        firstTitle.rightAnchor.constraint(equalTo: firstServiceView.rightAnchor, constant: -12).isActive = true
        firstTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        firstServiceView.addSubview(scanLabel)
        scanLabel.topAnchor.constraint(equalTo: firstServiceView.topAnchor).isActive = true
        scanLabel.leftAnchor.constraint(equalTo: firstServiceView.leftAnchor).isActive = true
        scanLabel.rightAnchor.constraint(equalTo: firstServiceView.rightAnchor).isActive = true
        scanLabel.heightAnchor.constraint(equalToConstant: 93).isActive = true
        
        firstServiceView.addSubview(scanScansLabel)
        scanScansLabel.topAnchor.constraint(equalTo: firstServiceView.topAnchor, constant: 30).isActive = true
        scanScansLabel.leftAnchor.constraint(equalTo: firstServiceView.leftAnchor).isActive = true
        scanScansLabel.rightAnchor.constraint(equalTo: firstServiceView.rightAnchor).isActive = true
        scanScansLabel.heightAnchor.constraint(equalToConstant: 130).isActive = true
    }
    
    func isNil() {
        firstServiceView.addSubview(mapView)
        mapView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        mapView.layer.cornerRadius = 25
        mapView.clipsToBounds = true
        mapView.topAnchor.constraint(equalTo: firstServiceView.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: firstServiceView.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: firstServiceView.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: firstServiceView.bottomAnchor, constant: -44).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
