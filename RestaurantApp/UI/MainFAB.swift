//
//  MainFAB.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 8/14/21.
//

import Foundation
import UIKit

class MainFAB : UIButton {
    
    init() {
        super.init(frame: .zero)
        
        layer.cornerRadius = 28
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addTarget(self, action: #selector(effects), for: UIControl.Event.touchUpInside)
        
        setTitleColor(Restaurant.shared.textColorOnButton, for: UIControl.State.normal)
        
        backgroundColor = Restaurant.shared.themeColor
        
        tintColor = Restaurant.shared.textColorOnButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("error fatal")
    }
    
    @objc func effects() {
        add3DMotion(withFeedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle.light)
    }
    
}
