//
//  AppDelegateValues.swift
//  On the Map
//
//  Created by Maha on 14/11/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import Foundation
import UIKit

struct AppDelegateValues {
    
    static let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // Set Values
    
    static func setAppDelegateVariabels(uniqueKey: String) {
        appDelegate?.uniqueKey = uniqueKey
    }
    
    static func setAppDelegateVariabels(objectId: String?) {
        appDelegate?.objectId = objectId
    }
    
    static func setAppDelegateVariabels(studentLocatios: [StudentLocation]) {
        appDelegate?.listOfStudentLocations.append(contentsOf: studentLocatios)
    }
    
    static func removeStudentLocatiosArray() {
        appDelegate?.listOfStudentLocations.removeAll()
    }
    
    // Get values
    
    static func getAppDelegateUniqueKey() -> String? {
        return appDelegate?.uniqueKey
    }
    
    static func getAppDelegateObjectId() -> String? {
        return appDelegate?.objectId
    }
    
    static func getAppDelegateStudentLocations () -> [StudentLocation]? {
        return appDelegate?.listOfStudentLocations
    }
    
}
