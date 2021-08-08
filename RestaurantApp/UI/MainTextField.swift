//
//  MainTextField.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/6/21.
//

import Foundation
import UIKit

class MainTextField: UITextField {
    
    let insets : UIEdgeInsets
    
    init(insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12), placeholderString: String) {
        self.insets = insets
        super.init(frame: CGRect.zero)
        
        textColor = Restaurant.shared.textColor
        
        let placeholderStringAttr = NSAttributedString(string: placeholderString, attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "747478")])
        attributedPlaceholder = placeholderStringAttr
        
        tintColor = Restaurant.shared.themeColor
        
        backgroundColor = UIColor(hexString: "F2F2F2")
        
        borderStyle = BorderStyle.none
        
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        
        font = UIFont.systemFont(ofSize: 15)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not yet been implemented")
    }
    
}
