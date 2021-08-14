//
//  AppDelegate.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/6/21.
//

import UIKit
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print("🚀 Launched! 🚀")
        
        // Firebase Configuration
        FirebaseApp.configure()
        
        // Sign In With Google Configuration
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        // Pre Built Sign Out Code
//        let auth = Auth.auth()
//        do {
//            try auth.signOut()
//        } catch let error as NSError {
//            print("Error signing out: \(error.localizedDescription)")
//        }
        
        // Birthday Notifcation Authorization Handler
        let center = UNUserNotificationCenter.current()
        let options : UNAuthorizationOptions = [.alert, .sound]
        center.requestAuthorization(options: options) { isGranted, error in
            if isGranted && error == nil {
                print("registered for notifcations")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        center.delegate = self
        
        // Log Analytics
        let root = Database.database().reference().child("Analytics").child("appSessions")
        let key = root.childByAutoId().key
        let params : [String : Any] = [
            "userId" : Auth.auth().currentUser?.uid ?? "newUser",
            "restaurantId" : Restaurant.shared.restaurantId,
            "time" : Int(Date().timeIntervalSince1970)
        ]
        let feed : [String : Any] = [
            key! : params
        ]
        root.updateChildValues(feed)
        print("success logging analytics")
        
        // Notifications
        Messaging.messaging().delegate = self
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  willPresent notification: UNNotification,
                                  withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                    -> Void) {
        let userInfo = notification.request.content.userInfo

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // ...

        // Print full message.
        print(userInfo)

        // Change this to your preferred presentation option
        completionHandler([[.alert, .sound]])
      }

      func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  didReceive response: UNNotificationResponse,
                                  withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        // ...

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print full message.
        print(userInfo)
      }


}
















