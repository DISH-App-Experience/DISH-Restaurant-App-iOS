//
//  MenuItemCVCell.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/15/21.
//

import UIKit

class MenuItemCVCell: UICollectionViewCell {
    
    static let identifier = "MenuItemCVCellID"
    
    let menuView : UIView = {
        let view = UIView()
        view.backgroundColor = Restaurant.shared.secondaryBackground
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let itemImageView : MainImageView = {
        let imageView = MainImageView()
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
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let itemDescLabel : UILabel = {
        let label = UILabel()
        label.text = "Desc"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let itemPriceLabel : UILabel = {
        let label = UILabel()
        label.text = "Price"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = Restaurant.shared.themeColor
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        backgroundColor = Restaurant.shared.backgroundColor
        
        addSubview(menuView)
        menuView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        menuView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        menuView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        menuView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        addSubview(itemImageView)
        itemImageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        itemImageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        itemImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        itemImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        
        addSubview(itemTitleLabel)
        itemTitleLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 10).isActive = true
        itemTitleLabel.leftAnchor.constraint(equalTo: menuView.leftAnchor, constant: 12).isActive = true
        itemTitleLabel.rightAnchor.constraint(equalTo: menuView.rightAnchor, constant: -12).isActive = true
        itemTitleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        addSubview(itemDescLabel)
        itemDescLabel.topAnchor.constraint(equalTo: itemTitleLabel.bottomAnchor, constant: 5).isActive = true
        itemDescLabel.leftAnchor.constraint(equalTo: menuView.leftAnchor, constant: 12).isActive = true
        itemDescLabel.rightAnchor.constraint(equalTo: menuView.rightAnchor, constant: -12).isActive = true
        itemDescLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        addSubview(itemPriceLabel)
        itemPriceLabel.topAnchor.constraint(equalTo: itemDescLabel.bottomAnchor, constant: 11).isActive = true
        itemPriceLabel.leftAnchor.constraint(equalTo: menuView.leftAnchor, constant: 12).isActive = true
        itemPriceLabel.rightAnchor.constraint(equalTo: menuView.rightAnchor, constant: -12).isActive = true
        itemPriceLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: self.bounds.size.width - 48, height: CGFloat())
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
    }
    
}
