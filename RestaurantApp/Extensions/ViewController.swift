//
//  ViewController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/6/21.
//

import UIKit
import MBProgressHUD

extension UIViewController {
    
    func showLoading() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    func hideLoading() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func add3DMotion(withFeedbackStyle style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred(intensity: 1.0)
    }
    
    func addErrorNotification() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.error)
    }
    
    func addSuccessNotification() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.success)
    }
    
    func moveToController(controller: UIViewController) {
        controller.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    func moveToInfoController(withEmail email: String) {
        let controller = SignUpInformationController()
        controller.email = email
        controller.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    func moveToTabbar() {
        let controller = TabBarController()
        controller.checkControllers()
        controller.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.present(controller, animated: true, completion: nil)
//        })
    }
    
    func moveToWelcomeController() {
        let controller = WelcomeController()
        controller.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    func moveToProfileController() {
        let controller = ProfileController()
        controller.backend()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func moveToMenuPage() {
        if let tabbar = tabBarController {
            tabbar.selectedIndex = 1
        }
    }
    
    func pushToController(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showMenuItem(menuItem: MenuItem) {
        let controller = MenuItemController()
        controller.item = menuItem
        controller.modalPresentationStyle = UIModalPresentationStyle.popover
        self.present(controller, animated: true, completion: nil)
    }
    
    func popAboutUsController() {
        let controller = AboutUs()
        self.present(controller, animated: true, completion: nil)
    }
    
    func simpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func customActionWithCancel(title: String, message: String, onConfirm: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes, continue", style: .default) { _ in onConfirm() })
        alert.addAction(UIAlertAction(title: "No, cancel", style: .cancel))
        return alert
    }
    
    func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: view.bounds.size.width - 48, height: CGFloat())
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
    }
    
    func combineDateWithTime(date: Date, time: Date) -> Date? {
        let calendar = NSCalendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var mergedComponents = DateComponents()
        mergedComponents.year = dateComponents.year
        mergedComponents.month = dateComponents.month
        mergedComponents.day = dateComponents.day
        mergedComponents.hour = timeComponents.hour
        mergedComponents.minute = timeComponents.minute
        mergedComponents.second = timeComponents.second
        
        return calendar.date(from: mergedComponents)
    }
    
    func isLightColor(color: UIColor) -> Bool {
       var white: CGFloat = 0.0
       color.getWhite(&white, alpha: nil)

       var isLight = false

       if white >= 0.5 {
           isLight = true
           NSLog("color is light: %f", white)
       } else {
          NSLog("Color is dark: %f", white)
       }

       return isLight
    }
    
}
