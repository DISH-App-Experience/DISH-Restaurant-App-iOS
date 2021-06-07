//
//  MainButton.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/6/21.
//

import Foundation
import UIKit

class MainButton : UIButton {
    
    init() {
        super.init(frame: .zero)
        
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        layer.cornerRadius = 10
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addTarget(self, action: #selector(effects), for: UIControl.Event.touchUpInside)
        
        setTitleColor(Restaurant.shared.textColorOnButton, for: UIControl.State.normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("error fatal")
    }
    
    @objc func effects() {
        add3DMotion(withFeedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle.light)
    }
    
}
