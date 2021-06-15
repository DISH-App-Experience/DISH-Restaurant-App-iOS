//
//  MenuCategoryCell.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/15/21.
//

import UIKit

class MenuCategoryCell: UICollectionViewCell {
    
    static let identifier = "MenuCategoryCellID"
    
    var key = ""
    
    var category : Category? {
        didSet {
            self.titleLabel.text = category!.name!
            self.key = category!.key!
        }
    }
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "hi"
        label.textAlignment = NSTextAlignment.center
        label.textColor = Restaurant.shared.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
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
