//
//  AboutUs.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/19/21.
//

import UIKit
import SDWebImage

class AboutUs: UIViewController {
    
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
        imageView.backgroundColor = Restaurant.shared.secondaryBackground
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.sd_setImage(with: URL(string: Restaurant.shared.logo)!)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 27)
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.center
        label.text = Restaurant.shared.name
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel : UITextView = {
        let label = UITextView()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = Restaurant.shared.textColor
        label.text = Restaurant.shared.restarantDesc
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
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.bottomAnchor.constraint(equalTo: infoView.topAnchor, constant: 49).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        infoView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
        
        infoView.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 13).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -18).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
    }
    
}
