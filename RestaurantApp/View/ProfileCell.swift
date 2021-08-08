//
//  ProfileCell.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/8/21.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    static var identifier = "myProfileCellIdentifier"
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = NSTextAlignment.left
        label.textColor = Restaurant.shared.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let responseLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = NSTextAlignment.right
        label.textColor = UIColor(hexString: "AAAAAA")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let sepView : UIView = {
        let view = UIView()
        view.backgroundColor = Restaurant.shared.secondaryBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        selectionStyle = SelectionStyle.none
        
        addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        addSubview(responseLabel)
        responseLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        responseLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        responseLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        responseLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        addSubview(sepView)
        sepView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        sepView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        sepView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        sepView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}
