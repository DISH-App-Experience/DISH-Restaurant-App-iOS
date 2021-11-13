//
//  MenuItemController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/9/21.
//

import UIKit
import SDWebImage

class MenuItemController: UIViewController {
    
    var item : MenuItem? {
        didSet {
            if let item = item {
                if let imageURL = item.imageUrl {
                    imageView.sd_setImage(with: URL(string: imageURL)!)
                }
                if let title = item.title {
                    titleLabel.text = title
                }
                if let price = item.price {
                    priceLabel.text = "$\(price)"
                }
                if let desc = item.desc {
                    descriptionLabel.text = desc
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
        imageView.backgroundColor = Restaurant.shared.secondaryBackground
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.text = "$"
        label.font = UIFont.boldSystemFont(ofSize: 27)
        label.textColor = Restaurant.shared.themeColor
        label.textAlignment = NSTextAlignment.right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel : UITextView = {
        let label = UITextView()
        label.text = "Title"
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
        
        view.backgroundColor = Restaurant.shared.themeColor
        
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
        
        infoView.addSubview(priceLabel)
        priceLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        priceLabel.widthAnchor.constraint(equalToConstant: 110).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
        
        infoView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: priceLabel.leftAnchor, constant: -25).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        infoView.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 13).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -18).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
    }
    
}
