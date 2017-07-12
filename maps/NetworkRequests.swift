//
//  NetworkRequests.swift
//  maps
//
//  Created by Mihir Thanekar on 7/9/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import Foundation
/// TODO: WORK IN PROGRESS
/// CLASS TO MAKE ANY NETWORK REQUESTß
class NetworkRequests {
    static func requestWith(requestType: String, requestURL: String, addValues: [String: String], httpBody: String?, isUdacityRequest: Bool? = nil, completionHandler: @escaping ([String: AnyObject]?, Error?)-> Void) {
        
        let baseURL = URL(string: requestURL)!
        var request = URLRequest(url: baseURL)
        request.httpMethod = requestType
        for value in addValues {
            request.addValue(value.value, forHTTPHeaderField: value.key)
        }
        
        request.httpBody = httpBody?.data(using: String.Encoding.utf8)
        request.timeoutInterval = 10
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            guard error == nil, let bytesData = data else {
                completionHandler(nil, error)
                print("problem")
                print(error ?? "dfds")
                return
            }
            
            //let deserializedJSONData: [String: AnyObject]
            do{
                let serializedJSONData = isUdacityRequest == true ? skipSecurityCharacters(udacityData: bytesData) : bytesData
                let deserializedJSONData = try JSONSerialization.jsonObject(with: serializedJSONData, options: .allowFragments) as! [String: AnyObject]
                completionHandler(deserializedJSONData, nil)
            }catch{
                completionHandler(nil, error)
            }
            
            
            
            
        })
        
        task.resume()
    }
    
    // If it's a Udacity request
    static func skipSecurityCharacters(udacityData: Data) -> Data {
        let range = Range(5 ..< udacityData.count)
        let newData = udacityData.subdata(in: range)
        return newData
    }
    
    static func getLocations(completionHandler: @escaping () -> Void) {
        let values: [String: String] = [
            "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
            "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        ]
        NetworkRequests.requestWith(requestType: Constants.requestType.GET.rawValue, requestURL: Constants.Udacity.studentLocationsURL, addValues: values, httpBody: nil, completionHandler: {(data, error) in
            //print(String(data: data, encoding: .utf8) ?? "Failure")
            guard let data = data, error == nil else {
                print("pin load err")
                return
            }
            
            let results = data["results"] as! [[String: AnyObject]]
            Annotations.MapPoints = results
            completionHandler()
        })
    }
    
    static func deleteSession() {
        var headers: [String: String] = [:]
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == Constants.Udacity.sessionCookie.cookieName {
                xsrfCookie = cookie
            }
        }
        if let xsrfCookie = xsrfCookie {    // nil check
            headers[Constants.Udacity.sessionCookie.headerName] = xsrfCookie.value
        }
        NetworkRequests.requestWith(requestType: Constants.requestType.DELETE.rawValue, requestURL: Constants.Udacity.sessionURL, addValues: headers, httpBody: nil, isUdacityRequest: true, completionHandler: {(data,error) in
            guard let data = data, error == nil else {
                print("Network failure.")
                return
            }
            
            print(data)
        })
    }
    
}
