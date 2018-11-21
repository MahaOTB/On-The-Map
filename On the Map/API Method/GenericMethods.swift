//
//  GenericMethod.swift
//  On the Map
//
//  Created by Maha on 13/11/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import Foundation
import SystemConfiguration

struct GenericMethod {
    
    // This struct contains Generic functions needed to handel Get, Post, put and delete httpMethods
    
    // Generic function to implement all Post methods requested from Udacity and Parse APIs
    
    static func postMethod<T: Decodable,E: Encodable>(isParseAPI: Bool = true, httpMethod: String = "POST" ,url: URL, httpBodyObject: E, objectType: T.Type, completionHandler: @escaping (T?, String?) -> Void){
        
        sessionConfig()
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = httpMethod
        
        if isParseAPI {
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        }
        
        do {
            let jsonEncoded = try JSONEncoder().encode(httpBodyObject)
            request.httpBody = jsonEncoded
        }catch{
            completionHandler(nil, error.localizedDescription)
        }
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error)  in
            
            if errorHandler(error: error) != nil {
                completionHandler(nil, error?.localizedDescription)
                return
            }
            
            // Handling HTTP Response
            if let httpResponseError = httpResponseHandler(response: response) {
                completionHandler(nil, "\(httpResponseError)")
            }
            
            guard var newData = data else {return}
            
            // SKIP the first 5 characters of the Udacity API response that used for security purposes
            if (!isParseAPI){
                let range = (5..<newData.count)
                newData = newData.subdata(in: range)
            }
            
            do {
                let jsonDecodedObject = try JSONDecoder().decode( objectType, from: newData)
                completionHandler(jsonDecodedObject, nil)
            }catch {
                completionHandler(nil, error.localizedDescription)
            }
            }.resume()
        
    }
    
    // Generic function to implement all Get methods requested from Udacity and Parse APIs
    
    static func getMethod<T: Decodable>(isParseAPI: Bool = true, url: URL, objectType: T.Type, completionHandler: @escaping (T?, String?) -> Void){
        
        sessionConfig()
        
        var request = URLRequest(url: url)
        
        if isParseAPI {
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error)  in
            
            
            if errorHandler(error: error) != nil {
                completionHandler(nil, error?.localizedDescription)
                return
            }
            
            // Handling HTTP Response
            if let errorDesc = httpResponseHandler(response: response) {
                completionHandler(nil, errorDesc)
            }
            
            guard var newData = data else {return}
            
            // SKIP the first 5 characters of the Udacity API response that used for security purposes
            if (!isParseAPI){
                let range = (5..<newData.count)
                newData = newData.subdata(in: range)
            }
            
            do {
                let jsonDecodedObject = try JSONDecoder().decode( objectType, from: newData)
                completionHandler(jsonDecodedObject, nil)
            }catch {
                completionHandler(nil, error.localizedDescription)
            }
            }.resume()
    }
    
    static func deleteMethod(completionHandler: @escaping (String?) -> Void) {
        
        sessionConfig()
        
        let url = UdacityApi.constructUdacityURL(methodName: "session")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if errorHandler(error: error) != nil {
                completionHandler(error?.localizedDescription)
                return
            }
            
            // Handling HTTP Response
            if let errorDesc = httpResponseHandler(response: response) {
                completionHandler(errorDesc)
            }
            
            completionHandler(nil)
            }.resume()
        
    }
    
    static func sessionConfig() {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.waitsForConnectivity = false
        sessionConfig.timeoutIntervalForRequest = 30
    }
    
    static func errorHandler(error: Error?) -> String? {
        
        if let error = error as NSError?, error.domain == NSURLErrorDomain && (error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorTimedOut || error.code == NSURLErrorNetworkConnectionLost || error.code == NSURLErrorUserAuthenticationRequired) {
            return error.localizedDescription
        }
        return nil
    }
    
    static func httpResponseHandler(response: URLResponse?) -> String? {
        
        if let httpResponse = response as? HTTPURLResponse {
            
            guard httpResponse.statusCode >= 200 , httpResponse.statusCode <= 299 else {
                let statusCode = httpResponse.statusCode
                return "\(Alerts.HTTPStatusCodeDescription) \(statusCode) \(HTTPURLResponse.localizedString(forStatusCode: statusCode))"
            }
        }
        return nil
    }
    
}
