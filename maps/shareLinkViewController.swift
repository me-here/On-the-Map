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
        let values = [Constants.Parse.parameters.AppID: Constants.Parse.values.appID,
                      Constants.Parse.parameters.APIKey: Constants.Parse.values.APIKey,
                      Constants.Parse.parameters.contentType: Constants.Parse.values.contentType
            
        ]
        
        print("Point -> (\(pointAnnotation.coordinate.latitude),\(pointAnnotation.coordinate.longitude))")
    
        self.pointAnnotation.subtitle = linkText
        
        let httBody = "{\"uniqueKey\": \"12b2z\", \"firstName\": \"Mihir\", \"lastName\": \"Thanekar\",\"mapString\": \"\(pointAnnotation.subtitle ?? "Unknown")\", \"mediaURL\": \"\(linkText)\",\"latitude\": \(pointAnnotation.coordinate.latitude), \"longitude\": \(pointAnnotation.coordinate.longitude)}"
        /*
        let httpBody = "{\"uniqueKey\": \"a2z\", \"firstName\": \"Mihir\", \"lastName\": \"Thanekar\",\"mapString\": \"\(String(describing: pointAnnotation.title))\", \"mediaURL\": \"\(linkText)\",\"latitude\": \(pointAnnotation.coordinate.latitude), \"longitude\": \(pointAnnotation.coordinate.longitude)}"
        */
        NetworkRequests.requestWith(requestType: Constants.requestType.POST.rawValue, requestURL: studentLocationURL, addValues: values, httpBody: httBody, completionHandler: {(data, error) in
            guard error == nil, let data = data else {
                print("error with POST")
                return
            }
                        
            //Annotations.pointsIAdded.append(self.pointAnnotation)   // TODO: FIX THIS LINE TO BE FOR ANNOTATION.MAPPOINTS
            
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
