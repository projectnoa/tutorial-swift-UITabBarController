//
//  item3.swift
//  UITabBarControllerExample
//
//  Created by Juan Reyes on 11/19/22.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class ViewController3: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true

        if let coordinates = mapView.userLocation.location?.coordinate {
            let coordinateRegion = MKCoordinateRegion(
                  center: coordinates,
                  latitudinalMeters: 1000,
                  longitudinalMeters: 1000)
            
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations
                         locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate

        mapView.mapType = MKMapType.standard

        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        
        mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "You are Here"
        
        mapView.addAnnotation(annotation)
    }
}
