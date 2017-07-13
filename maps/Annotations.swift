//
//  model.swift
//  maps
//
//  Created by Mihir Thanekar on 7/10/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import Foundation
import MapKit

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
        var tempStudentInfo = [StudentInformation]()
        for studentInfo in allPoints {
            let info = StudentInformation(studentInfo: studentInfo)
            tempStudentInfo.append(info) //model.allStudentsInfo.append(info)
        }
        model.allStudentsInfo = tempStudentInfo
    }
    
    static var userID = ""
    static var firstName = ""
    static var lastName = ""
    static var shouldReloadData = true
    static var tableViewShouldReloadData = true
}
