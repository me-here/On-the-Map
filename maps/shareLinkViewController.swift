//
//  shareLinkViewController.swift
//  maps
//
//  Created by Mihir Thanekar on 7/10/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import UIKit
import MapKit

class shareLinkViewController: UIViewController {
    
    var pointAnnotation = MKPointAnnotation()
    var region = MKCoordinateRegion()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var linkField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func cancel(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        guard let linkText = linkField.text, !linkText.isEmpty else {
            self.displayError(message: "empty text field")
            return
        }
        print(linkText)
        // make post request
        
        let values = [Constants.Parse.parameters.AppID: Constants.Parse.values.appID,
                      Constants.Parse.parameters.APIKey: Constants.Parse.values.APIKey,
                      Constants.Parse.parameters.contentType: Constants.Parse.values.contentType
            
        ]
        
        print("Point -> (\(pointAnnotation.coordinate.latitude),\(pointAnnotation.coordinate.longitude))")
        
        self.pointAnnotation.subtitle = linkText
        
        let httBody = "{\"uniqueKey\": \"\(self.uniqueHash(numberOfCharacters: 6))\", \"firstName\": \"\(model.firstName)\", \"lastName\": \"\(model.lastName)\",\"mapString\": \"\(model.mapString))\", \"mediaURL\": \"\(linkText)\",\"latitude\": \(pointAnnotation.coordinate.latitude), \"longitude\": \(pointAnnotation.coordinate.longitude)}"
        
        NetworkRequests.requestWith(requestType: Constants.requestType.POST.rawValue, requestURL: Constants.Udacity.studentLocationsURL, addValues: values, httpBody: httBody, completionHandler: {
            (data, error) in
                guard error == nil, let data = data else {
                    self.displayError(message: "Error with POST")
                    return
                }
            
                print(data)
                model.shouldReloadData = true
                model.tableViewShouldReloadData = true
                DispatchQueue.main.async {
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkField.delegate = self
        DispatchQueue.main.async {
            self.mapView.setCenter(.init(latitude: 0, longitude: 0), animated: false)   // ensure that some zoom will occur
            self.mapView.addAnnotation(self.pointAnnotation)
            self.mapView.setRegion(self.region, animated: true)
            setupButton(self.submitButton, color: UIColor(red: 139/255,green: 195/255,blue: 74/255,alpha: 1))
        }
        
    }
    
     private func uniqueHash(numberOfCharacters: Int) -> String {
        let alphaNumerics = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        var hash = ""
        
        for _ in 1...numberOfCharacters {
            let randomCharacterIndex = Int(arc4random_uniform(UInt32(alphaNumerics.characters.count)))
            let randStringCharIndex = alphaNumerics.index(alphaNumerics.startIndex, offsetBy: randomCharacterIndex)
            let char = alphaNumerics.substring(to: randStringCharIndex)
            hash.append(char)
        }
        return hash
    }
    
    private func displayError(title:String? = "Failure",message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(.init(title: "Ok", style: .cancel, handler: {_ in
            DispatchQueue.main.async {
                alert.dismiss(animated: true, completion: nil)
            }
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension shareLinkViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


