//
//  Annotations.swift
//  maps
//
//  Created by Mihir Thanekar on 7/10/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import Foundation
import MapKit

struct Annotations {
    static var MapPoints = [[String: AnyObject]]()
    static var MapAnnotations = [MKPointAnnotation]()
    //static var shouldReloadData = true
    static var pointsIAdded = [MKPointAnnotation]()
}
