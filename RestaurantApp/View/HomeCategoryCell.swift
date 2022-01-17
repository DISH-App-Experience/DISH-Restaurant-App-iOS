//
//  HomeCategoryCell.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 1/1/22.
//

import UIKit

class HomeCategoryCell: UICollectionViewCell {
    
    static let identifier = "HomeCategoryCellIdentifier"
    
    let menuView : UIView = {
        let view = UIView()
        view.backgroundColor = Restaurant.shared.secondaryBackground
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Random"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Restaurant.shared.textColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        addSubview(menuView)
        menuView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        menuView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        menuView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        menuView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        menuView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 7).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 7).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -7).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
