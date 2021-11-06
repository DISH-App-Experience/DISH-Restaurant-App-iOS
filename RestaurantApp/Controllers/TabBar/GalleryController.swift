//
//  GalleryController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/10/21.
//

import UIKit
import Firebase
import SDWebImage
import MBProgressHUD

class GalleryController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Variables
    
    var imagePicker = UIImagePickerController()
    
    var photos = [Photo]()
    
    var collectionView : UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Restaurant.shared.backgroundColor
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        view.backgroundColor = Restaurant.shared.backgroundColor
        
        title = "Image Gallery"
        
        updateViewConstraints()
        delegates()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        backend()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        guard let collectionView = collectionView else { return }
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(named: "backgroundColor")
        collectionView.register(ImageGalleryCell.self, forCellWithReuseIdentifier: ImageGalleryCell.identifier)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func backend() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        photos.removeAll()
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("photos").observe(DataEventType.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let photo = Photo()
                photo.image = value["url"] as? String
                photo.key = value["key"] as? String
                self.photos.append(photo)
            }
            self.collectionView!.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    private func delegates() {
        collectionView!.delegate = self
        collectionView!.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.reverse()
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageGalleryCell.identifier, for: indexPath) as! ImageGalleryCell
        
        if let imageString = photos[indexPath.row].image {
            cell.photoView.sd_setImage(with: URL(string: imageString)!, completed: nil)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = ViewPhotoController()
        controller.photo = photos[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let half = self.view.frame.size.width / 2
        return CGSize(width: half - 35, height: half - 35)
    }
    

}
