//
//  UIImage.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 8/18/21.
//

import Foundation
import UIKit

extension UIImage{
    func tint(color: UIColor, blendMode: CGBlendMode) -> UIImage {
        let drawRect = CGRect(x: 0,y: 0,width: size.width,height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
}
