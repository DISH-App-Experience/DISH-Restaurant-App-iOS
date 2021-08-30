//
//  CustomizeItemOrderController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 8/17/21.
//

import UIKit

class CustomizeItemOrderController: UIViewController, UITextFieldDelegate {
    
    var item : MenuItem? {
        didSet {
            if let item = item {
                if let imageURL = item.imageUrl {
                    imageView.sd_setImage(with: URL(string: imageURL)!)
                }
                if let title = item.title {
                    titleLabel.text = title
                }
                if let price = item.price {
                    priceLabel.text = "$\(price)"
                }
            }
        }
    }
    
    let infoView : UIView = {
        let view = UIView()
        view.backgroundColor = Restaurant.shared.backgroundColor
        view.layer.cornerRadius = 50
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Restaurant.shared.secondaryBackground
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = Restaurant.shared.textColor
        label.textAlignment = NSTextAlignment.left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.text = "$"
        label.font = UIFont.boldSystemFont(ofSize: 27)
        label.textColor = Restaurant.shared.themeColor
        label.textAlignment = NSTextAlignment.right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let notesTextfield : MainTextField = {
        let textField = MainTextField(placeholderString: "Notes:")
        textField.backgroundColor = Restaurant.shared.secondaryBackground
        textField.keyboardType = UIKeyboardType.default
        return textField
    }()
    
    let mainButton : MainButton = {
        let button = MainButton()
        button.backgroundColor = Restaurant.shared.themeColor
        button.setTitle("Add To Order", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(mainButtonPressed), for: UIControl.Event.touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Restaurant.shared.backgroundColor
        
        updateViewConstraints()

        // Do any additional setup after loading the view.
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        view.addSubview(infoView)
        infoView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        infoView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        infoView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        infoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 175).isActive = true
        
        view.addSubview(imageView)
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.bottomAnchor.constraint(equalTo: infoView.topAnchor, constant: 49).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        infoView.addSubview(priceLabel)
        priceLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        priceLabel.widthAnchor.constraint(equalToConstant: 85).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
        
        infoView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: priceLabel.leftAnchor, constant: -25).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
        
        infoView.addSubview(notesTextfield)
        notesTextfield.delegate = self
        notesTextfield.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 45).isActive = true
        notesTextfield.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        notesTextfield.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        notesTextfield.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        infoView.addSubview(mainButton)
        mainButton.topAnchor.constraint(equalTo: notesTextfield.bottomAnchor, constant: 29).isActive = true
        mainButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        mainButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    @objc func mainButtonPressed() {
        let orderObject = OrderObject()
        orderObject.menuItem = item
        orderObject.notes = self.notesTextfield.text
        
        if orderObject.notes == "" {
            let alert = UIAlertController(title: "Wait!", message: "Add a note to your menu item?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "No, Proceed", style: UIAlertAction.Style.cancel, handler: { action in
                self.proceed(withOrderObject: orderObject)
            }))
            alert.addAction(UIAlertAction(title: "Yes, Add Notes", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            proceed(withOrderObject: orderObject)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func proceed(withOrderObject object: OrderObject?) {
        orderObjects.append(object!)
        let alert = UIAlertController(title: "Success", message: "Item Added To Order Successfully", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { action in
            self.backTwo()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }

}
