//
//  NoConnection.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 8/9/21.
//

import UIKit

class NoConnection: UIViewController {
    
    let logoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "appIcon")
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let noInternetTitle : UILabel = {
        let label = UILabel()
        label.text = "Limited to No Connection"
        label.alpha = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        constraints()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    private func constraints() {
        view.addSubview(logoImageView)
        logoImageView.widthAnchor.constraint(equalToConstant: 93).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 93).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        animations()
    }
    
    private func animations() {
        UIView.animate(withDuration: 1, delay: 1) {
            self.logoImageView.frame.origin.y -= 200
        } completion: { yMinus in
            if yMinus {
                self.view.addSubview(self.noInternetTitle)
                self.noInternetTitle.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 20).isActive = true
                self.noInternetTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
                self.noInternetTitle.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
                self.noInternetTitle.heightAnchor.constraint(equalToConstant: 55).isActive = true
                UIView.animate(withDuration: 0.5) {
                    self.noInternetTitle.alpha = 1
                } completion: { titleFade in
                    if titleFade {
                        print("done with animations")
                    }
                }

            }
        }

    }

}
