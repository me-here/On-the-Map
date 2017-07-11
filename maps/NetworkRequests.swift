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
    static func requestWith(requestType: String, requestURL: String, addValues: [String: String], httpBody: String?, completionHandler: @escaping (Data?, Error?)-> Void) {
        
        let baseURL = URL(string: requestURL)!
        var request = URLRequest(url: baseURL)
        request.httpMethod = requestType
        for value in addValues {
            request.addValue(value.value, forHTTPHeaderField: value.key)
        }
                //print(request.allHTTPHeaderFields)
        request.httpBody = httpBody?.data(using: String.Encoding.utf8)
        request.timeoutInterval = 10
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            if error != nil {
                completionHandler(nil, error)
                print("problem")
                print(error ?? "dfds")
                return
            }
            
            completionHandler(data!, nil)
            
        })
        
        task.resume()
    }
    
    /*// If it's a Udacity request
     static func skipSecurityCharacters(udacityData: inout Data) -> Data {
    
     }*/
    
    static func getLocations(completionHandler: @escaping () -> Void) {
        let values: [String: String] = [
            "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
            "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        ]
        NetworkRequests.requestWith(requestType: "GET", requestURL: Constants.Udacity.studentLocationsURL, addValues: values, httpBody: nil, completionHandler: {(data, error) in
            //print(String(data: data, encoding: .utf8) ?? "Failure")
            guard error == nil else {
                print("pin load err")
                return
            }
            do{
                let locations = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]
                let results = locations["results"] as! [[String: AnyObject]]
                Annotations.MapPoints = results
                completionHandler()
            }catch{
                print("err")
                return
            }
        })
    }

}
