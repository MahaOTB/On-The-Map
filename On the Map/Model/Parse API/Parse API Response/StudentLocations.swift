//
//  StudentLocation.swift
//  On the Map
//
//  Created by Maha on 14/11/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import Foundation
import MapKit

struct StudentLocationResult: Decodable {
    
    let results: [StudentLocation]
    
}

class StudentLocation: Codable {
    
    var objectId: String?
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    var createdAt: String?
    var updatedAt: String?
    
    init(uniqueKey: String?, firstName: String?, lastName: String?, latitude: Double?, longitude: Double?, mapString: String?, mediaURL: String?) {
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
    }
    
}
