//
//  OrderBundle.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 8/17/21.
//

import UIKit
import Firebase

class OrderBundle: NSObject {
    
    var orderItems = orderObjects
    
    var location : Location?
    
    var dineType : DineType?
    
    var paymentType : MethodOfPayment?
    
    var time : Int = Int(Date().timeIntervalSince1970)
    
    var uid : String = Auth.auth().currentUser!.uid

}
