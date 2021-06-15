//
//  ViewPhotoController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/15/21.
//

import UIKit
import Firebase
import SDWebImage

class ViewPhotoController: UIViewController {
    
    var photo : Photo? {
        didSet {
            if let photo = photo {
                if let imageUrl = photo.image {
                    self.imageView.sd_setImage(with: URL(string: imageUrl)!)
                }
            }
        }
    }
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.backgroundColor = Restaurant.shared.secondaryBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    // MARK: - Overriden Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Restaurant.shared.themeColor
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        updateViewConstraints()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = Restaurant.shared.textColorOnButton
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.backButtonTitle = "Back"
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        constraints()
    }
    
    // MARK: - Private Functions
    
    private func constraints() {
        view.addSubview(imageView)
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 389).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}
