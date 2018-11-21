//
//  UdacityApi.swift
//  On the Map
//
//  Created by Maha on 14/11/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import Foundation
import UIKit

struct UdacityApi {
    
    // This struct contains all methods requested form Udacity API
    
    static func createSession(username: String, password: String, completion: @escaping (String?)-> Void){
        
        let loginInformation = Login(username: username, password: password)
        let httpBodyObject = UdacityPost(udacity: loginInformation)
        
        let url = constructUdacityURL(methodName: "session")
        
        GenericMethod.postMethod(isParseAPI: false, url: url, httpBodyObject: httpBodyObject, objectType: Authentication.self){ (results, errorDescription) in
            
            guard errorDescription == nil else{
                completion("\(errorDescription!)\n\(Alerts.NotAuthrized)")
                return
            }
            
            guard let results = results else{
                completion(Alerts.ServerReturnNoData)
                return
            }
            
            if !results.account.isRegistered {
                completion(Alerts.NotRegistered)
            }
            
            DispatchQueue.main.async {
                AppDelegateValues.setAppDelegateVariabels(uniqueKey: results.account.key)
                completion(nil)
            }
            
        }
    }
    
    static func constructUdacityURL(methodName: String) -> URL{
        
        // URL Components
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.udacity.com"
        components.path = "/api/" + methodName
        
        return components.url!
    }
    
}
