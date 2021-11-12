//
//  MenuItemCell.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/15/21.
//

import UIKit

class MenuItemCell: UITableViewCell {
    
    static let identifier = "MenuItemCellID"
    
    let largeView : UIView = {
        let view = UIView()
        view.backgroundColor = Restaurant.shared.secondaryBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        return view
    }()
    
    let itemImageView : CustomImageView = {
        let imageView = CustomImageView()
        imageView.layer.cornerRadius = 37.5
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = Restaurant.shared.backgroundColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let itemTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let itemDescLabel : UILabel = {
        let label = UILabel()
        label.text = "Desc"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let itemCatLabel : UILabel = {
        let label = UILabel()
        label.text = "Desc"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let itemPriceLabel : UILabel = {
        let label = UILabel()
        label.text = "Price"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Restaurant.shared.themeColor
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCell.SelectionStyle.none
        
        backgroundColor = UIColor.clear
        
        addSubview(largeView)
        largeView.topAnchor.constraint(equalTo: topAnchor, constant: 7).isActive = true
        largeView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        largeView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        largeView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7).isActive = true
        
        addSubview(itemImageView)
        itemImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 13).isActive = true
        itemImageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        itemImageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        itemImageView.centerYAnchor.constraint(equalTo: largeView.centerYAnchor).isActive = true
        
        addSubview(itemTitleLabel)
        itemTitleLabel.topAnchor.constraint(equalTo: largeView.topAnchor, constant: 15).isActive = true
        itemTitleLabel.leftAnchor.constraint(equalTo: itemImageView.rightAnchor, constant: 13).isActive = true
        itemTitleLabel.rightAnchor.constraint(equalTo: largeView.rightAnchor, constant: -22).isActive = true
        itemTitleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        addSubview(itemDescLabel)
        itemDescLabel.topAnchor.constraint(equalTo: itemTitleLabel.bottomAnchor, constant: 1).isActive = true
        itemDescLabel.leftAnchor.constraint(equalTo: itemImageView.rightAnchor, constant: 13).isActive = true
        itemDescLabel.rightAnchor.constraint(equalTo: largeView.rightAnchor, constant: -22).isActive = true
        itemDescLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        addSubview(itemPriceLabel)
        itemPriceLabel.topAnchor.constraint(equalTo: itemDescLabel.bottomAnchor, constant: 3).isActive = true
        itemPriceLabel.leftAnchor.constraint(equalTo: itemImageView.rightAnchor, constant: 13).isActive = true
        itemPriceLabel.rightAnchor.constraint(equalTo: largeView.rightAnchor, constant: -22).isActive = true
        itemPriceLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        addSubview(itemCatLabel)
        itemCatLabel.topAnchor.constraint(equalTo: itemDescLabel.bottomAnchor, constant: 3).isActive = true
        itemCatLabel.leftAnchor.constraint(equalTo: itemImageView.rightAnchor, constant: 13).isActive = true
        itemCatLabel.rightAnchor.constraint(equalTo: largeView.rightAnchor, constant: -22).isActive = true
        itemCatLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
