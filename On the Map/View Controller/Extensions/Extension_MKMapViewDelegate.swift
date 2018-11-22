//
//  Extension_MKMapViewDelegate.swift
//  On the Map
//
//  Created by Maha on 15/11/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import Foundation
import MapKit

extension StudentLocationsOnMapViewController: MKMapViewDelegate {
    
    // create a view with a "right callout accessory view"
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        let reuseId = "pinID"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .blue
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            guard let urlString = view.annotation?.subtitle else {
                present(Alerts.formulateAlert(message: Alerts.NoURLProvided), animated: true)
                return
            }
            
            let error = ParseApi.openUrl(urlString: urlString!)
            guard error == nil else {
                present(Alerts.formulateAlert(message: error!), animated: true)
                return
            }
        }
    }
    
}


extension ShareLinkViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        let reuseId = "PinMe"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.image = UIImage(named: "MapMaker")
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}
