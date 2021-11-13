//
//  LocationsController.swift
//  RestaurantApp
//
//  Created by JJ Zapata on 6/10/21.
//

import UIKit
import MapKit
import Firebase
import CoreLocation

class LocationsController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locations = [Location]()
    
    let locationManager = CLLocationManager()
    
    let mapView : MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Restaurant.shared.backgroundColor
        title = "Our Locations"
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        updateViewConstraints()
        
        backend()

        // Do any additional setup after loading the view.
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
    }
    
    private func backend() {
        showLoading()
        Database.database().reference().child("Apps").child(Restaurant.shared.restaurantId).child("locations").observe(DataEventType.childAdded) { snapshot in
            if let value = snapshot.value as? [String : Any] {
                let location = Location()
                location.city = value["city"] as? String
                location.image = value["image"] as? String
                location.lat = value["lat"] as? Double
                location.long = value["long"] as? Double
                location.state = value["state"] as? String
                location.street = value["street"] as? String
                location.zip = value["zip"] as? Int
                self.locations.append(location)
            }
            self.addAnnotations()
        }
    }
    
    private func addAnnotations() {
        for location in locations {
            let pin = MKPointAnnotation()
            pin.coordinate = CLLocationCoordinate2D(latitude: location.lat!, longitude: location.long!)
            pin.title = "\(location.long!)"
            pin.subtitle = "\(location.lat!)"
            let region = MKCoordinateRegion.init(center: pin.coordinate, latitudinalMeters: 1500, longitudinalMeters: 1500)
            mapView.setRegion(region, animated: true)
            mapView.addAnnotation(pin)
        }
        hideLoading()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "mapViewRAVN")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "mapViewRAVN")
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "locationPinImage")!
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let longTitle = Double(view.annotation!.title!!)!
        let latSubtitle = Double(view.annotation!.subtitle!!)!
        let longitude: CLLocationDegrees = longTitle
        let latitude: CLLocationDegrees = latSubtitle
        let regionDistance:CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = Restaurant.shared.name
        mapItem.openInMaps(launchOptions: options)
        
        //        let address = "\(streetAddressTF.text!), \(cityTF.text!), \(stateTF.text!) \(zipcodeTF.text!)"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
