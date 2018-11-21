//
//  ParseApi.swift
//  On the Map
//
//  Created by Maha on 14/11/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import Foundation
import UIKit

struct ParseApi {
    
    // MARK: Get methods requested form Parse API
    
    static func getStudentLocations(completionHandler: @escaping (_ isCompleted: Bool, _ errorDescription: String?) -> Void) {
        
        let limit = 100
        
        let parameters = [URLQueryItem(name: "limit", value: "\(limit)"), URLQueryItem(name: "order", value: "-updatedAt")]
        let url = constructParseURL(methodName: "StudentLocation", parameters: parameters)
        
        GenericMethod.getMethod(url: url, objectType: StudentLocationResult.self){ (studentLocationsArray, errorDescription) in
            
            guard errorDescription == nil else {
                completionHandler(false, errorDescription)
                return
            }
            
            guard let studentLocationsArray = studentLocationsArray else{
                return
            }
            
            AppDelegateValues.removeStudentLocatiosArray()
            AppDelegateValues.setAppDelegateVariabels(studentLocatios: studentLocationsArray.results)
            
            completionHandler(true, nil)
        }
        
    }
    
    static func getAStudentLocation(completionHandler: @escaping (_ isPinned: Bool?, _ errorDescription: String?) -> Void) {
        
        guard AppDelegateValues.getAppDelegateObjectId() == nil else {
            return
        }
        
        guard let uniqeKey = AppDelegateValues.getAppDelegateUniqueKey() else {
            return
        }
        
        let parameters = [URLQueryItem(name: "where", value: "{\"uniqueKey\":\"\(uniqeKey)\"}"), URLQueryItem(name: "order", value: "-updatedAt")]
        let url = ParseApi.constructParseURL(methodName: "StudentLocation", parameters: parameters)
        
        GenericMethod.getMethod(url: url, objectType: StudentLocationResult.self) { (studentLocation, errorDescription) in
            
            guard errorDescription == nil else {
                completionHandler(nil, errorDescription)
                return
            }
            
            guard let studentLocation = studentLocation?.results else {
                return
            }
            
            if studentLocation.count > 0 {
                AppDelegateValues.setAppDelegateVariabels(objectId: studentLocation[0].objectId ?? nil)
                completionHandler(true, nil)
                return
            }
            
            completionHandler(false, nil)
        }
    }
    
    // MARK: Post methods to post information to Parse API
    
    static func postOrUpdateStudentLocation(firstName: String, lastName: String, latitude: Double, longitude: Double, mapString: String, mediaURL: String, completionHandler: @escaping (_ errorDescription: String?) -> Void) {
        
        var HTTPMethod = "POST"
        let objectID = AppDelegateValues.getAppDelegateObjectId()
        let uniqeKey = AppDelegateValues.getAppDelegateUniqueKey()
        
        let url = constructParseURL(methodName: "StudentLocation/\(objectID ?? "")")
        
        let studentLocationObject = StudentLocation(uniqueKey: uniqeKey, firstName: firstName, lastName: lastName, latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: mediaURL)
        
        // If object id is nil then create new location -> Post http method will be used
        // else use Put http method to update student location
        if objectID != nil {
            HTTPMethod = "PUT"
        }
        
        // The response of this request would be (objectId and createdAt) or updated At
        GenericMethod.postMethod(httpMethod: HTTPMethod ,url: url, httpBodyObject: studentLocationObject, objectType: StudentLocation.self) { (results, errorDescription) in
            
            guard errorDescription == nil else {
                completionHandler(errorDescription)
                return
            }
            
            guard let _ = results else {
                return
            }
            
            completionHandler(nil)
        }
    }
    
    // MARK: Functions
    
    static func constructParseURL(methodName: String, parameters: [URLQueryItem] = []) -> URL{
        
        // URL Components
        var components = URLComponents()
        components.scheme = "https"
        components.host = "parse.udacity.com"
        components.path = "/parse/classes/" + methodName
        
        if !parameters.isEmpty {
            components.queryItems = [URLQueryItem]()
            components.queryItems?.append(contentsOf: parameters)
        }
        
        return components.url!
    }
    
    static func openUrl(urlString: String) -> String? {
        
        let app = UIApplication.shared
        if let urlToOpen = URL(string: urlString) {
            
            // Check whether an app is available to handle a URL scheme.
            let success = app.canOpenURL(urlToOpen)
            if success {
                app.open(urlToOpen, options: [:] )
            }else {
                return Alerts.NoAppToOpenUrl
            }
            
        }else {
            return Alerts.NotValidUrl
        }
        return nil
    }
    
}
