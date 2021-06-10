//
//  HomeActionCell.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/9/21.
//

import UIKit

class HomeActionCell: UICollectionViewCell {
    
    var action : HomeAction? {
        didSet {
            if let action = action {
                if let title = action.title {
                    titleLabel.text = title
                }
                if let image = action.image {
                    imageView.image = image
                }
            }
        }
    }
    
    static let identifier = "HomeActionCellIdentifier"
    
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
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 2
        return imageView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Random"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Restaurant.shared.textColorOnButton
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        addSubview(menuView)
        menuView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        menuView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        menuView.rightAnchor.constraint(equalTo: rightAnchor, constant: -7.5).isActive = true
        menuView.leftAnchor.constraint(equalTo: leftAnchor, constant: 7.5).isActive = true
        
        menuView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: menuView.topAnchor, constant: 15).isActive = true
        imageView.leftAnchor.constraint(equalTo: menuView.leftAnchor, constant: 12).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 27).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 27).isActive = true
        
        menuView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 11).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: menuView.leftAnchor, constant: 12).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: menuView.rightAnchor, constant: -12).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 19).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
