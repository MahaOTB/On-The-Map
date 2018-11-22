//
//  Alert.swift
//  On the Map
//
//  Created by Maha on 13/11/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import Foundation
import UIKit

struct Alerts {
    
    static let AlertDismissAction = "Dismiss"
    static let AlertOpenAction = "Open"
    static let AlertOverwriteAction = "Overwrite"
    static let ErrorTitle = "Error"
    static let ErrorHandelingRequestTitle = "Error handling your request"
    static let Warning = "Warning"
    static let EmptyFieldsTitle = "Empty Fields"
    static let OpenUrlTitle = "You are about to open this url"
    static let HTTPStatusCodeDescription = "The status code is:"
    static let ServerReturnNoData = "Udacity server return no data"
    static let EmptyFieldsBody = "Please entry your username and password"
    static let NotRegistered = "You are not registered in Udacity.com"
    static let NoAppToOpenUrl = "No app is available to handle this URL scheme"
    static let NotValidUrl = "This is not a valid URL"
    static let NoURLProvided = "No URL provided"
    static let OverwriteLocation = "You have already posted your location. Would you want to overwrite your current location?"
    static let CanNotAccessLocation = "On The Map app can not access your current location"
    static let NotAuthrized = "You may entered a wrong username or password"
    static let UnableForwardGeocode = "Unable to Forward Geocode Address"
    static let NoMatchingLocation = "No Matching Location Found"
    static let EnterLocationString = "Please enter the location string"
    
    static func formulateAlert(title: String = ErrorTitle, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.AlertDismissAction, style: .cancel, handler: nil))
        
        return alert
    }

}
