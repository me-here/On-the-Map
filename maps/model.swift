//
//  model.swift
//  maps
//
//  Created by Mihir Thanekar on 7/13/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import Foundation
import CoreLocation

struct StudentInformation {
    let location: CLLocationCoordinate2D
    let link: String
    let name: String
    
    init(studentInfo: [String: AnyObject]) {
        self.location = CLLocationCoordinate2D(latitude: studentInfo["latitude"] as? Double ?? 0, longitude: studentInfo["longitude"] as? Double ?? 0)
        self.link = studentInfo["mediaURL"] as? String ?? ""
        self.name = "\(studentInfo["firstName"] as? String ?? "Unknown") \(studentInfo["lastName"] as? String ?? "name")"
    }
}

class model {
    static var allStudentsInfo = [StudentInformation]()
    
    init(allPoints: [[String: AnyObject]]) {
        for studentInfo in allPoints {
            let info = StudentInformation(studentInfo: studentInfo)
            model.allStudentsInfo.append(info)
        }
    }
    
    static var userID = ""
    static var firstName = ""
    static var lastName = ""
}
