//
//  PushNotificationSender.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 8/13/21.
//

import Foundation
import UIKit

class PushNotificationSender {
    
    func sendPushNotification(to token: String, title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "priority" : "high",
                                           "notification" : ["title" : title, "body" : body, "badge" : 1, "sound" : "default"],
                                           "data" : ["user" : "test_id"]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAm63IQAc:APA91bEJvsc2VcRBs8t4u_fr_YoIWtDKdU6fIlHUw6J6PZCEPlhEYwMwTO7je8ngCHlEvijwPiXGOZeEELwFuGmkmCHeHHHUbZo43RqFoVWl8uZFXv3bYbKTvSJuSm6m6pum4GGorYJr", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
    
}
