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
        guard let locationText = locationLabel.text else {
            displayError(message: "Empty field/s")
            return
        }
        let geocoder = CLGeocoder()
        DispatchQueue.main.async {
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
            
            guard let location = placemark?[0].location?.coordinate else {
                print("location err")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            let regionn = placemark?[0].region as! CLCircularRegion
            showPinController.region = MKCoordinateRegionMakeWithDistance(location, regionn.radius, regionn.radius)
            
            showPinController.pointAnnotation.coordinate = location
            showPinController.pointAnnotation.title = "\(model.firstName) \(model.lastName)"  // Get Name from info
            print(showPinController.pointAnnotation.title ?? "no title")
            
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
    
    private func displayError(title:String? = "Geocoding failure",message: String) {
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
