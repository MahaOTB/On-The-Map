//
//  StudentLocationsOnMapViewController.swift
//  On the Map
//
//  Created by Maha on 14/11/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import UIKit
import MapKit

class StudentLocationsOnMapViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var barbiPinIcon: UIBarButtonItem!
    @IBOutlet weak var barbiLogout: UIBarButtonItem!
    
    // MARK: Properties
    
    let tableViewControllerID = "studentListTableViewController"
    let showAddPinVCSegue = "showAddPinViewController"
    private let noUrlProvided: String = "No URL Provided"
    private let noNameProvided: String = "No Name Provided"
    var locationManager: CLLocationManager?
    
    // MARK: LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        removeAllAnnotations()
        updateMapView()
    }
    
    // MARK: Actions
    
    @IBAction func pinIconTapped(_ sender: Any) {
        
        // Check if this user had registered his location before
        
        setUI(enabled: false)
        
        guard AppDelegateValues.getAppDelegateObjectId() == nil else {
            OverwriteLocationAlert(title: Alerts.Warning, message: Alerts.OverwriteLocation)
            setUI(enabled: true)
            return
        }
        
        ParseApi.getAStudentLocation { (isPinned, errorDescription) in
            
            guard errorDescription == nil else {
                DispatchQueue.main.async {
                    self.present(Alerts.formulateAlert(title: Alerts.ErrorHandelingRequestTitle, message: errorDescription!), animated: true)
                }
                return
            }
            
            // If the user location not registered allow him to pin his location
            guard let isPinned = isPinned, isPinned  else  {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: self.showAddPinVCSegue, sender: self)
                }
                return
            }
            
            // else show alert ask him to overwrite his previouse location
            DispatchQueue.main.async {
                self.OverwriteLocationAlert(title: Alerts.Warning, message: Alerts.OverwriteLocation)
            }
            self.setUI(enabled: true)
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        
        GenericMethod.deleteMethod { (errorDescription) in
            
            guard errorDescription == nil else {
                DispatchQueue.main.async {
                    self.present(Alerts.formulateAlert(title: Alerts.ErrorHandelingRequestTitle, message: errorDescription!), animated: true)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
    }
    
    // MARK: Functions
    
    func getStudentLocations() {
        
        activityIndicator.startAnimating()
        
        ParseApi.getStudentLocations { (studentLocationsArray, errorDescription) in
            
            // Check if error encounted
            guard errorDescription == nil else {
                DispatchQueue.main.async {
                    self.present(Alerts.formulateAlert(title: Alerts.ErrorHandelingRequestTitle, message: errorDescription!), animated: true)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.pinStudentLocations()
                self.activityIndicator.stopAnimating()
            }
            
        }
    }
    
    func pinStudentLocations() {
        
        var annotations = [MKPointAnnotation]()
        
        for studentLocation in AppDelegateValues.getAppDelegateStudentLocations() ?? [] {
            
            guard let latitude = studentLocation.latitude, let longiture = studentLocation.longitude else{
                continue
            }
            
            let lat = CLLocationDegrees(latitude)
            let long = CLLocationDegrees(longiture)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // Create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            
            if let first = studentLocation.firstName ,let last = studentLocation.lastName, !first.isEmpty, !last.isEmpty {
                annotation.title = "\(first) \(last)"
            }else {
                annotation.title = self.noNameProvided
            }
            
            if let mediaURL = studentLocation.mediaURL, !mediaURL.isEmpty {
                annotation.subtitle = mediaURL
            }else {
                annotation.subtitle = self.noUrlProvided
            }
            
            annotation.coordinate = coordinate
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
    func OverwriteLocationAlert(title: String, message: String) {
        
        let alert = Alerts.formulateAlert(title: title, message: message)
        
        alert.addAction(UIAlertAction(title: Alerts.AlertOverwriteAction, style: .default, handler: { _  in
            self.performSegue(withIdentifier: self.showAddPinVCSegue, sender: self)
        } ))
        
        self.present(alert, animated: true)
    }
    
    func setUI(enabled: Bool) {
        barbiPinIcon.isEnabled = enabled
        barbiLogout.isEnabled = enabled
    }
    
    func updateMapView() {
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.startUpdatingLocation()
        }
    }
    
    func removeAllAnnotations() {
        
        let annotations: [MKAnnotation] = mapView.annotations
        
        guard annotations.count != 0 else {
            return
        }
        
        for annotation in annotations {
            mapView.removeAnnotation(annotation)
        }
    }
    
}

// MARK: CLLocationManagerDelegate methods

extension StudentLocationsOnMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        getStudentLocations()
    }
}
