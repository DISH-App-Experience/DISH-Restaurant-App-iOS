//
//  OrderLocationCell.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 8/17/21.
//

import UIKit

class OrderLocationCell: UITableViewCell {
    
//    var action : HomeAction? {
//        didSet {
//            if let action = action {
//                if let title = action.title {
//                    titleLabel.text = title
//                }
//                if let image = action.image {
//                    imageView.image = image
//                }
//            }
//        }
//    }
    
    static let identifier = "OrderLocationCellIdentifier"
    
    let mainView : UIView = {
        let view = UIView()
        view.backgroundColor = Restaurant.shared.secondaryBackground
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Location Name"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCell.SelectionStyle.none
        
        addSubview(mainView)
        mainView.topAnchor.constraint(equalTo: topAnchor, constant: 9.5).isActive = true
        mainView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9.5).isActive = true
        mainView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        mainView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -18).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 18).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
