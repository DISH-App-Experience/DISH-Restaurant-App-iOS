//
//  PaymentType.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 8/17/21.
//

import UIKit
import Stripe
import Firebase
import Alamofire

enum MethodOfPayment {
    case rewards, card, paypal, none
}

class CheckoutController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var shouldPopToRoot : Bool = false
    
    var goodToPass = false
    
    var bundle : OrderBundle? {
        didSet {
            if let bundle = bundle {
                var priceTotal : Double = 0
                var scanTotal : Int = 0
                let items = bundle.orderItems
                for item in items {
                    let price = item.menuItem!.price!
                    let scan = item.menuItem!.scanPrice!
                    priceTotal += price
                    scanTotal += scan
                }
                let mutableAttr1 = NSMutableAttributedString(string: "$\(priceTotal)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30), NSAttributedString.Key.foregroundColor : Restaurant.shared.themeColor])
                let mutableAttr2 = NSMutableAttributedString(string: " / \(scanTotal) Scans", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor.systemGray])
                mutableAttr1.append(mutableAttr2)
                self.priceLabel.attributedText = mutableAttr1
            }
        }
    }
    
    // Production
//    let methods = ["Rewards Points", "Credit Card"]
//    let methodDescriptions = ["Use your scanned visits to checkout", "Checkout with your credit card"]
//    let methodImages = [UIImage(systemName: "crown"), UIImage(systemName: "creditcard")]
//    let methodImagesSelected = [UIImage(systemName: "crown.fill"), UIImage(systemName: "creditcard.fill")]
//    let protocolMethods = [MethodOfPayment.rewards, MethodOfPayment.card, MethodOfPayment.paypal]
    
    // Development
    let methods = ["Rewards Points"]
    let methodDescriptions = ["Use your scanned visits to checkout"]
    let methodImages = [UIImage(systemName: "crown")]
    let methodImagesSelected = [UIImage(systemName: "crown.fill")]
    let protocolMethods = [MethodOfPayment.rewards]
    
    let mainView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Restaurant.shared.backgroundColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Restaurant.shared.secondaryBackground
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.sd_setImage(with: URL(string: Restaurant.shared.logo)!)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 7
        imageView.layer.borderColor = Restaurant.shared.backgroundColor.cgColor
        return imageView
    }()
    
    let yourOrderLabel : UILabel = {
        let label = UILabel()
        label.text = "Your Order"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = Restaurant.shared.textColor
        label.numberOfLines = 3
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.text = "Price"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = Restaurant.shared.textColor
        label.numberOfLines = 3
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.alwaysBounceVertical = false
        tableView.alwaysBounceHorizontal = false
        tableView.register(PaymentMethodCell.self, forCellReuseIdentifier: PaymentMethodCell.identifier)
        return tableView
    }()
    
    let mainButton : MainButton = {
        let button = MainButton()
        button.backgroundColor = Restaurant.shared.themeColor
        button.setTitle("Checkout", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(mainButtonPressed), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let totalPriceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = Restaurant.shared.textColor
        label.numberOfLines = 2
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var blurView : UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.systemMaterial))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.alpha = 0
        return blurView
    }()
    
    let cardView : UIView = {
        let view = UIView()
        view.backgroundColor = Restaurant.shared.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.alpha = 0
        return view
    }()
    
    let blurButton : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.isHidden = true
        button.addTarget(self, action: #selector(hidePaymentView), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let cardViewLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.left
        label.textColor = Restaurant.shared.textColor
        return label
    }()
    
    let paymentTextField : STPPaymentCardTextField = {
        let textField = STPPaymentCardTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = Restaurant.shared.themeColor
        return textField
    }()
    
    let paymentMainButton : MainButton = {
        let button = MainButton()
        button.backgroundColor = Restaurant.shared.themeColor
        button.setTitle("Checkout", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(mainButtonPressed), for: UIControl.Event.touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        view.backgroundColor = Restaurant.shared.secondaryBackground
        navigationController?.navigationBar.barTintColor = Restaurant.shared.secondaryBackground
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        updateViewConstraints()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(popsToRoot), userInfo: nil, repeats: true)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        view.addSubview(mainView)
        mainView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mainView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 75).isActive = true
        mainView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height - 300).isActive = true
        
        mainView.addSubview(imageView)
        imageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        
        mainView.addSubview(yourOrderLabel)
        yourOrderLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        yourOrderLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
        yourOrderLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
        yourOrderLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        mainView.addSubview(priceLabel)
        priceLabel.topAnchor.constraint(equalTo: yourOrderLabel.bottomAnchor, constant: 16).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(mainButton)
        mainButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -16).isActive = true
        mainButton.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 16).isActive = true
        mainButton.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -16).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        view.addSubview(totalPriceLabel)
        totalPriceLabel.bottomAnchor.constraint(equalTo: mainButton.topAnchor).isActive = true
        totalPriceLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -16).isActive = true
        totalPriceLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 16).isActive = true
        totalPriceLabel.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        mainView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 32).isActive = true
        tableView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 16).isActive = true
        tableView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -16).isActive = true
        tableView.bottomAnchor.constraint(equalTo: totalPriceLabel.topAnchor).isActive = true
        
        setupPaymentView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return methods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PaymentMethodCell.identifier, for: indexPath) as! PaymentMethodCell
        cell.methodImageView.image = methodImages[indexPath.row]
        cell.methodImageView.tintColor = Restaurant.shared.secondaryBackground
        cell.titleLabel.text = methods[indexPath.row]
        cell.titleLabel.textColor = Restaurant.shared.textColor
        cell.descLabel.text = methodDescriptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PaymentMethodCell
        priceCheck(withPaymentMethod: protocolMethods[indexPath.row])
        self.bundle?.paymentType = protocolMethods[indexPath.row]
        if cell.isChecked == false {
            cell.isChecked = true
            cell.methodImageView.image = methodImagesSelected[indexPath.row]
            cell.methodImageView.tintColor = Restaurant.shared.themeColor
            cell.mainView.backgroundColor = Restaurant.shared.secondaryBackground
            cell.mainView.layer.borderColor = Restaurant.shared.themeColor.cgColor
            cell.checkMarkImage.isHidden = false
        } else {
            cell.isChecked = false
            cell.methodImageView.image = methodImages[indexPath.row]
            cell.methodImageView.tintColor = Restaurant.shared.secondaryBackground
            cell.mainView.backgroundColor = Restaurant.shared.backgroundColor
            cell.mainView.layer.borderColor = Restaurant.shared.secondaryBackground.cgColor
            cell.checkMarkImage.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PaymentMethodCell
        cell.isChecked = false
        cell.methodImageView.image = methodImages[indexPath.row]
        cell.methodImageView.tintColor = Restaurant.shared.secondaryBackground
        cell.mainView.backgroundColor = Restaurant.shared.backgroundColor
        cell.mainView.layer.borderColor = Restaurant.shared.secondaryBackground.cgColor
        cell.checkMarkImage.isHidden = true
        self.bundle?.paymentType = MethodOfPayment.none
        priceCheck(withPaymentMethod: MethodOfPayment.none)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    func priceCheck(withPaymentMethod method: MethodOfPayment) {
        switch method {
        case MethodOfPayment.rewards:
            var scanPrice : Double = 0
            for item in bundle!.orderItems {
                let itemScanPrice = item.menuItem!.scanPrice!
                scanPrice += Double(itemScanPrice)
            }
            totalPriceLabel.text = "Price: \(scanPrice) Scans"
            goodToPass = true
        case MethodOfPayment.card:
            var buyPrice : Double = 0
            for item in bundle!.orderItems {
                let itemBuyPrice = item.menuItem!.price!
                buyPrice += itemBuyPrice
            }
            totalPriceLabel.text = "Price: $\(buyPrice)"
            goodToPass = true
        default:
            goodToPass = false
            totalPriceLabel.text = ""
        }
    }
    
    @objc func mainButtonPressed() {
        showLoading()
        if goodToPass {
            switch self.bundle!.paymentType! {
            case MethodOfPayment.rewards:
                print("rewards")
                var scanPrice : Double = 0
                for item in bundle!.orderItems {
                    let itemScanPrice = item.menuItem!.scanPrice!
                    scanPrice += Double(itemScanPrice)
                }
                let locationKey = self.bundle!.location!.key
                enoughPoints(forLocation: locationKey, points: scanPrice, completion: { hasEnough in
                    if hasEnough {
                        self.hideLoading()
                        let alert = UIAlertController(title: "Wait! Before you continue:", message: "If you are taking out or dining in, please be at the location! Your reward points will now be removed", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Yes, Proceed", style: UIAlertAction.Style.default, handler: { action in
                            self.removePoints(forLocation: locationKey)
                            self.nextScreen()
                        }))
                        alert.addAction(UIAlertAction(title: "No, Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        self.hideLoading()
                        self.simpleAlert(title: "Error", message: "You don't have enough points for this location to checkout! Sorry")
                    }
                })
            case MethodOfPayment.card:
                print("card")
                var buyPrice : Double = 0
                for item in bundle!.orderItems {
                    let itemBuyPrice = item.menuItem!.price!
                    buyPrice += itemBuyPrice
                }
                cardViewLabel.text = "Card Info: $\(buyPrice)"
                showPaymentView()
                hideLoading()
            default:
                print("other")
                hideLoading()
                simpleAlert(title: "Error", message: "An error occured, please reselect a method of payment")
            }
        } else {
            hideLoading()
            simpleAlert(title: "Error", message: "Please select a valid payment method")
        }
    }
    
    private func enoughPoints(forLocation location: String?, points: Double?, completion: @escaping (Bool) -> Void) {
        let uid = Auth.auth().currentUser!.uid
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(uid).child("rewards").child(location!).child("value").observe(DataEventType.value) { locationSnap in
            if let value = locationSnap.value as? Int {
                if Double(value) >= points! {
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
    
    private func removePoints(forLocation location: String?) {
        var scanPrice : Double = 0
        for item in bundle!.orderItems {
            let itemScanPrice = item.menuItem!.scanPrice!
            scanPrice += Double(itemScanPrice)
        }
        let uid = Auth.auth().currentUser!.uid
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(uid).child("rewards").child(location!).child("value").observeSingleEvent(of: DataEventType.value) { locationSnap in
            if let value = locationSnap.value as? Int {
                let newValue = value - Int(scanPrice)
                Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("Users").child(uid).child("rewards").child(location!).child("value").setValue(newValue)
            } else {
                self.simpleAlert(title: "Error", message: "Could not add point: Access code 505")
            }
        }
    }
    
    private func nextScreen() {
        let controller = SuccessScreen()
        controller.addConfetti()
        controller.analytics()
        controller.bundle = self.bundle
        controller.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(controller, animated: true) {
            self.shouldPopToRoot = true
        }
    }
    
    private func setupPaymentView() {
        view.addSubview(blurView)
        blurView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(blurButton)
        blurButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        blurButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        blurButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(cardView)
        cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        cardView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 85).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 175).isActive = true
        
        cardView.addSubview(cardViewLabel)
        cardViewLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10).isActive = true
        cardViewLabel.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 16).isActive = true
        cardViewLabel.rightAnchor.constraint(equalTo: cardView.rightAnchor, constant: -16).isActive = true
        cardViewLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        cardView.addSubview(paymentTextField)
        paymentTextField.topAnchor.constraint(equalTo: cardViewLabel.bottomAnchor, constant: 16).isActive = true
        paymentTextField.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 16).isActive = true
        paymentTextField.rightAnchor.constraint(equalTo: cardView.rightAnchor, constant: -16).isActive = true
        paymentTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        cardView.addSubview(paymentMainButton)
        paymentMainButton.topAnchor.constraint(equalTo: paymentTextField.bottomAnchor, constant: 16).isActive = true
        paymentMainButton.leftAnchor.constraint(equalTo: paymentTextField.leftAnchor).isActive = true
        paymentMainButton.rightAnchor.constraint(equalTo: paymentTextField.rightAnchor).isActive = true
        paymentMainButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    private func showPaymentView() {
        UIView.animate(withDuration: 0.3) {
            self.blurView.alpha = 1
            self.cardView.alpha = 1
            self.blurButton.isHidden = false
        } completion: { isCompleted in
            if isCompleted {
                self.paymentTextField.becomeFirstResponder()
            }
        }
    }
    
    @objc func hidePaymentView() {
        if paymentTextField.isFirstResponder {
            paymentTextField.resignFirstResponder()
        } else {
            UIView.animate(withDuration: 0.3) {
                self.blurView.alpha = 0
                self.cardView.alpha = 0
                self.blurButton.isHidden = true
            }
        }
    }
    
    @objc func popsToRoot() {
        if shouldPopToRoot {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

}
