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
                print(error ?? "Something went wrong")
                return
            }
            
            //let deserializedJSONData: [String: AnyObject]
            do{
                let serializedJSONData = isUdacityRequest == true ? skipSecurityCharacters(udacityData: bytesData) : bytesData
                guard let deserializedJSONData = try JSONSerialization.jsonObject(with: serializedJSONData, options: .allowFragments) as? [String: AnyObject] else {
                    print("Deserialization failure")
                    completionHandler(nil, error)
                    return
                }
                
                completionHandler(deserializedJSONData, nil)
            }catch{
                completionHandler(nil, error)
            }
        })
        
        task.resume()
    }
    
    // If it's a Udacity request
    private static func skipSecurityCharacters(udacityData: Data) -> Data {
        let range = Range(5 ..< udacityData.count)
        let newData = udacityData.subdata(in: range)
        return newData
    }
}
