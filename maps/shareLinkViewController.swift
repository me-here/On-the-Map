//
//  shareLinkViewController.swift
//  maps
//
//  Created by Mihir Thanekar on 7/10/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import UIKit
import MapKit

class shareLinkViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {

    var pointAnnotation = MKPointAnnotation()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var linkField: UITextField!
    @IBAction func cancel(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func submit(_ sender: Any) {
        guard let linkText = linkField.text else {
            print("empty text field")
            return
        }
        print(linkText)
        // make post request
        let studentLocationURL = "https://parse.udacity.com/parse/classes/StudentLocation"
        let values = ["X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
                      "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY",
                      "Content-Type": "Content-Type"
        ]
        
    
        let httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Mihir\", \"lastName\": \"Thanekar\",\"mapString\": \"\(String(describing: pointAnnotation.title))\", \"mediaURL\": \"\(linkText)\",\"latitude\": \(pointAnnotation.coordinate.latitude), \"longitude\": \(pointAnnotation.coordinate.longitude)}"
        
        NetworkRequests.requestWith(requestType: "POST", requestURL: studentLocationURL, addValues: values, httpBody: httpBody, completionHandler: {(data, error) in
            guard error == nil, let data = data else {
                print("error with POST")
                return
            }
            
            print(String(data: data, encoding: .utf8)!)
            self.pointAnnotation.subtitle = linkText
            Annotations.pointsIAdded.append(self.pointAnnotation)
            
            DispatchQueue.main.async {
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        
        })
        
    
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.mapView.addAnnotation(self.pointAnnotation)
            self.mapView.setCenter(self.pointAnnotation.coordinate, animated: true)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    

}
