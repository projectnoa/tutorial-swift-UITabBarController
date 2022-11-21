//
//  ViewController3.swift
//  TabBarControllerSample
//
//  Created by Juan Mueller on 11/19/22.
//  www.ajourneyforwisdom.com

import Foundation
import UIKit
import MapKit
import CoreLocation

class ViewController3: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    // Outlet for mapView
    @IBOutlet weak var mapView: MKMapView!
    // Location manager property
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        // Call the viewdidload super
        super.viewDidLoad()
        // Initialize location manager
        locationManager = CLLocationManager()
        // Configure location manager to request for location permission
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        // Configure map view
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Check if permissions are not available
        if manager.authorizationStatus == .denied ||
            manager.authorizationStatus == .restricted ||
            manager.authorizationStatus == .notDetermined {
            return
        }
        // Trigger location retrieval
        locationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations
                         locations: [CLLocation]) {
        // Initialize coordinate with user location data
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        // initialize default map span and region
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        // Set map region to frame the mapView on a specific region
        mapView.setRegion(region, animated: true)
        // Initialize map annotation (pin)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "You are Here"
        // Add annotation on map view
        mapView.addAnnotation(annotation)
    }
}
