//
//  HomeMenuCell.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/9/21.
//

import UIKit
import SDWebImage

class HomeMenuCell: UICollectionViewCell {
    
    var menuItem : MenuItem? {
        didSet {
            if let item = menuItem {
                if let url = item.imageUrl {
                    imageView.sd_setImage(with: URL(string: url)!, completed: nil)
                }
                if let title = item.title {
                    titleLabel.text = title
                }
                if let price = item.price {
                    priceLabel.text = "$\(price)"
                }
            }
        }
    }
    
    static let identifier = "HomeMenuCellIdentifier"
    
    let menuView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#F2F2F2")
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.backgroundColor = UIColor(hexString: "#F2F2F2")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Random"
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Restaurant.shared.textColorOnButton
        return label
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.text = "$0.00"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Restaurant.shared.themeColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        addSubview(menuView)
        menuView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        menuView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        menuView.rightAnchor.constraint(equalTo: rightAnchor, constant: 7.5).isActive = true
        menuView.leftAnchor.constraint(equalTo: leftAnchor, constant: 7.5).isActive = true
        
        menuView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: menuView.topAnchor, constant: 13).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        menuView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: menuView.leftAnchor, constant: 7).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: menuView.rightAnchor, constant: -7).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        menuView.addSubview(priceLabel)
        priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: menuView.leftAnchor, constant: 7).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: menuView.rightAnchor, constant: -7).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
