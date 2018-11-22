//
//  ShareLocationViewController.swift
//  On the Map
//
//  Created by Maha on 17/11/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import UIKit
import MapKit

class ShareLocationViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var tvAddress: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Properties
    
    let shareLinkViewControllerSegue = "ShareLinkViewControllerSegue"
    var geocoder = CLGeocoder()
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    // MARK: LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvAddress.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: Actions
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func findMeOnTheMap(_ sender: Any) {
        
        activityIndicator.startAnimating()
        forwardGeocodes()
    }
    
    // MARK: Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == shareLinkViewControllerSegue {
            
            let vc = segue.destination as! ShareLinkViewController
            vc.mapString = tvAddress.text
            vc.latitude = latitude
            vc.longitude = longitude
            
        }
    }
    
    func forwardGeocodes() {
        
        // forward geocodes the address string and stores the resulting latitude and longitude
        
        var coordinate: CLLocationCoordinate2D?
        
        geocoder.geocodeAddressString(tvAddress.text) { (placemarks, error) in
            
            coordinate = self.processResponse(withPlacemarks: placemarks, error: error)
            
            self.activityIndicator.stopAnimating()
            
            guard coordinate != nil else {
                return
            }
            
            self.latitude = coordinate?.latitude
            self.longitude = coordinate?.longitude
            
            self.performSegue(withIdentifier: self.shareLinkViewControllerSegue, sender: self)
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
