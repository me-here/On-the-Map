//
//  AddLocationViewController.swift
//  maps
//
//  Created by Mihir Thanekar on 7/10/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var locationLabel: UITextField!
    @IBAction func cancel(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationLabel.delegate = self
        locationLabel.returnKeyType = .done
    }

    @IBAction func findOnMap(_ sender: Any) {
        guard let locationText = locationLabel.text, !locationText.isEmpty else {
            displayError(message: "Empty field/s")
            return
        }
        
        let geocoder = CLGeocoder()
        DispatchQueue.main.async {  // Spin the wheel to let user know of geocoding
            self.activityIndicator.startAnimating()
        }
        
        geocoder.geocodeAddressString(locationText, completionHandler: {(placemark, error) in
            guard error == nil else {
                self.displayError(message: "Geocode failure.")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            
            guard let showPinController = self.storyboard?.instantiateViewController(withIdentifier: "showPin") as? shareLinkViewController else {
                print("something went wrong")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            
            guard let location = placemark?[0].location?.coordinate else {  // There has to be 1 because that's what we requested
                print("location err")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            // Since CLRegion radius is deprecated, a cast to CLCircularRegion lets us access the properties
            guard let regionn = placemark?[0].region as? CLCircularRegion else {
                self.displayError(title: "Geocoding failure", message: "No region found")
                return
            }
            
            model.mapString = locationText

            showPinController.region = MKCoordinateRegionMakeWithDistance(location, regionn.radius, regionn.radius)
            showPinController.pointAnnotation.coordinate = location
            showPinController.pointAnnotation.title = "\(model.firstName) \(model.lastName)"  // Get Name from info
            
            DispatchQueue.main.async{
                self.activityIndicator.stopAnimating()
                self.present(showPinController, animated: false, completion: nil)
            }

        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
