//
//  MainTextField.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/6/21.
//

import Foundation
import UIKit

class MainTextField: UITextField {
    
    init(placeholderString: String) {
        super.init(frame: .zero)
        
        textColor = Restaurant.shared.textColor
        
        let placeholderStringAttr = NSAttributedString(string: placeholderString, attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "747478")])
        attributedPlaceholder = placeholderStringAttr
        
        tintColor = Restaurant.shared.themeColor
        
        backgroundColor = UIColor(hexString: "F2F2F2")
        
        borderStyle = BorderStyle.roundedRect
        
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        
        font = UIFont.systemFont(ofSize: 15)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("error fatal")
    }
    
}
