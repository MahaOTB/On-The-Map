//
//  ShareLinkViewController.swift
//  On the Map
//
//  Created by Maha on 17/11/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ShareLinkViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mediaUrl: UITextView!
    
    // MARK: Properties
    
    var mapString: String?
    var locationManager: CLLocationManager!
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    // MARK: LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mediaUrl.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateMapView()
    }
    
    // MARK: Actions
    
    @IBAction func submitCurrentLocation(_ sender: Any) {
        
        // Post user data
        ParseApi.postOrUpdateStudentLocation(firstName: "TEST", lastName: "TEST", latitude: Double(latitude ?? 0), longitude: Double(longitude ?? 0), mapString: mapString ?? "", mediaURL: self.mediaUrl.text) { (errorDescription) in
            
            guard errorDescription == nil else {
                DispatchQueue.main.async {
                    self.present(Alerts.formulateAlert(title: Alerts.ErrorHandelingRequestTitle, message: errorDescription!), animated: true)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.navigationController!.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Functions
    
    func updateMapView() {
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) -> CLLocationCoordinate2D? {
        
        var coordinate: CLLocationCoordinate2D?
        var location: CLLocation?
        
        guard error == nil else {
            present(Alerts.formulateAlert(message: "\(Alerts.UnableForwardGeocode) \(error!)"), animated: true)
            return nil
        }
        
        if let placemarks = placemarks, placemarks.count > 0 {
            location = placemarks.first?.location
        }
        
        guard location != nil else {
            present(Alerts.formulateAlert(message: "\(Alerts.NoMatchingLocation)"), animated: true)
            return nil
        }
        
        coordinate = location!.coordinate
        
        return coordinate
    }
}

// MARK: CLLocationManagerDelegate methods

extension ShareLinkViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        guard latitude != nil, longitude != nil else {
            self.present(Alerts.formulateAlert(title: Alerts.Warning, message: Alerts.CanNotAccessLocation), animated: true)
            return
        }
        
        let currentLocation = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let region = MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = currentLocation
        
        mapView.addAnnotation(annotation)
        self.mapView.setRegion(region, animated: true)
    }
}
