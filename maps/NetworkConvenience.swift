//
//  NetworkConvenience.swift
//  maps
//
//  Created by Mihir Thanekar on 7/14/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import Foundation
extension NetworkRequests {
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
        
        self.requestWith(requestType: Constants.requestType.DELETE.rawValue, requestURL: Constants.Udacity.sessionURL, addValues: headers, httpBody: nil, isUdacityRequest: true, completionHandler: {(data,error) in
            guard let data = data, error == nil else {
                print("Network failure.")
                return
            }
            
            StudentInformation.shouldReloadData = true
            StudentInformation.tableViewShouldReloadData = true
            print(data)
        })
    }
    
    static func getName(err: @escaping (String)-> ()) {
        NetworkRequests.requestWith(requestType: Constants.requestType.GET.rawValue, requestURL: Constants.Udacity.usersURL + StudentInformation.userID, addValues: [:], httpBody: nil, isUdacityRequest: true, completionHandler: {
            (data, error) in
            guard error == nil, let data = data else {
                err("Network error")
                return
            }
            guard let user = data["user"] as? [String: AnyObject],
                let firstName = user["first_name"] as? String,
                let lastName = user["last_name"] as? String else {
                    err("Could not get username")
                    return
            }
            
            StudentInformation.firstName = firstName
            StudentInformation.lastName = lastName
            print(firstName, lastName)
        })
    }
    
    static func login(email: String, password: String, err: @escaping (String) -> (), completion: @escaping () -> ()) {
        let headers = ["Accept": "application/json",
                       "Content-Type": "application/json"]
        let httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
        
        NetworkRequests.requestWith(requestType: Constants.requestType.POST.rawValue, requestURL: Constants.Udacity.sessionURL, addValues: headers, httpBody: httpBody,isUdacityRequest: true, completionHandler: {(data, error) in
            guard let data = data, error == nil else {
                err("No network.")
                return
            }
            
            guard let account = data["account"] as? [String: AnyObject],
                let registered = account["registered"] as? Bool,
                let key = account["key"] as? String else {
                    err("Account not registered or incorrect username/ password.")
                    return
            }
            
            StudentInformation.userID = key
            
            guard let session = data["session"] as? [String: AnyObject],
                let id = session["id"] as? String else {
                    err(/*title: "GET Failure", message:*/ "Couldn't retreive session id")
                    return
            }
            
            print(id)
            print(registered)
            completion()
        })

    }
    
    static func reloadData(err: @escaping (String) -> (), completion: @escaping () -> ()) {
        let values: [String: String] = [    // headers
            Constants.Parse.parameters.AppID: Constants.Parse.values.appID,
            Constants.Parse.parameters.APIKey: Constants.Parse.values.APIKey
        ]
        
        NetworkRequests.requestWith(requestType: Constants.requestType.GET.rawValue, requestURL: Constants.Udacity.studentLocationsGETURL, addValues: values, httpBody: nil, completionHandler: {(data, error) in
            guard let data = data, error == nil else {
                err("Pin loading error")
                return
            }
            //print(data)
            
            guard let results = data["results"] as? [[String: AnyObject]] else {
                err("Error with GETting map pins")
                return
            }
            _ = model(allPoints: results)
            //StudentInformation.shouldReloadData = true
            //StudentInformation.tableViewShouldReloadData = true
            
            completion()
        })
        print("Reloaded map")
    }
    
    static func shareLink(linkToShare: String, latitude: Double, longitude: Double, err: @escaping (String) -> (), completion: @escaping () -> ()) {
        let values = [Constants.Parse.parameters.AppID: Constants.Parse.values.appID,
                      Constants.Parse.parameters.APIKey: Constants.Parse.values.APIKey,
                      Constants.Parse.parameters.contentType: Constants.Parse.values.contentType
        ]
        
        
        
        let httBody = "{\"uniqueKey\": \"\(StudentInformation.userID)\", \"firstName\": \"\(StudentInformation.firstName)\", \"lastName\": \"\(StudentInformation.lastName)\",\"mapString\": \"\(StudentInformation.mapString))\", \"mediaURL\": \"\(linkToShare)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
        
        NetworkRequests.requestWith(requestType: Constants.requestType.POST.rawValue, requestURL: Constants.Udacity.studentLocationsURL, addValues: values, httpBody: httBody, completionHandler: {
            (data, error) in
            guard error == nil, let data = data else {
                err("Error with POST")
                return
            }
            
            print(data)
            StudentInformation.shouldReloadData = true
            StudentInformation.tableViewShouldReloadData = true
            
            completion()
        })

    }
}
