//
//  OrderCell.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 8/17/21.
//

import UIKit

class OrderCell: UITableViewCell {
    
    static let identifier = "OrderItemCellIdentifier"
    
    let mainView : UIView = {
        let view = UIView()
        view.backgroundColor = Restaurant.shared.secondaryBackground
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let itemImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = Restaurant.shared.backgroundColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCell.SelectionStyle.none
        
        addSubview(mainView)
        mainView.topAnchor.constraint(equalTo: topAnchor, constant: 9.5).isActive = true
        mainView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9.5).isActive = true
        mainView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        mainView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        addSubview(itemImageView)
        itemImageView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 15).isActive = true
        itemImageView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 15).isActive = true
        itemImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        itemImageView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -15).isActive = true
        
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 15).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -11).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: itemImageView.rightAnchor, constant: 11).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        addSubview(descLabel)
        descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        descLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -11).isActive = true
        descLabel.leftAnchor.constraint(equalTo: itemImageView.rightAnchor, constant: 11).isActive = true
        descLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
