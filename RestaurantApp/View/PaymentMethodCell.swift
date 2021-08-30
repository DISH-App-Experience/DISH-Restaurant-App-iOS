//
//  PaymentMethodCell.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 8/18/21.
//

import UIKit

class PaymentMethodCell: UITableViewCell {
    
    static let identifier = "PaymentMethodCellIdentifier"
    
    let mainView : UIView = {
        let view = UIView()
        view.backgroundColor = Restaurant.shared.backgroundColor
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 2
        view.layer.borderColor = Restaurant.shared.secondaryBackground.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let checkMarkView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 9
        view.layer.borderColor = Restaurant.shared.secondaryBackground.cgColor
        view.layer.borderWidth = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let checkMarkImage : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 9
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.tintColor = Restaurant.shared.themeColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let methodImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let descLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.systemGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 3
        return label
    }()
    
    var isChecked : Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCell.SelectionStyle.none
        
        addSubview(mainView)
        mainView.topAnchor.constraint(equalTo: topAnchor, constant: 9.5).isActive = true
        mainView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9.5).isActive = true
        mainView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        mainView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        mainView.addSubview(checkMarkView)
        checkMarkView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 16).isActive = true
        checkMarkView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 16).isActive = true
        checkMarkView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        checkMarkView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        mainView.addSubview(checkMarkImage)
        checkMarkImage.isHidden = true
        checkMarkImage.topAnchor.constraint(equalTo: checkMarkView.topAnchor).isActive = true
        checkMarkImage.leftAnchor.constraint(equalTo: checkMarkView.leftAnchor).isActive = true
        checkMarkImage.widthAnchor.constraint(equalTo: checkMarkView.widthAnchor).isActive = true
        checkMarkImage.heightAnchor.constraint(equalTo: checkMarkView.heightAnchor).isActive = true
        
        mainView.addSubview(methodImageView)
        methodImageView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 16).isActive = true
        methodImageView.leftAnchor.constraint(equalTo: checkMarkView.rightAnchor, constant: 14).isActive = true
        methodImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        methodImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        mainView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: methodImageView.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: methodImageView.rightAnchor, constant: 16).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        mainView.addSubview(descLabel)
        descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        descLabel.leftAnchor.constraint(equalTo: methodImageView.rightAnchor, constant: 16).isActive = true
        descLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        descLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
