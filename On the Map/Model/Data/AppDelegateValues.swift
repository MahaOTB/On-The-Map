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
    
    // Get values
    
    static func getAppDelegateUniqueKey() -> String? {
        return appDelegate?.uniqueKey
    }
    
    static func getAppDelegateObjectId() -> String? {
        return appDelegate?.objectId
    }
    
}
