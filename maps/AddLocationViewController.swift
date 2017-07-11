//
//  AddLocationViewController.swift
//  maps
//
//  Created by Mihir Thanekar on 7/10/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var locationLabel: UITextField!
    @IBAction func cancel(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationLabel.delegate = self
        locationLabel.returnKeyType = .done
        // Do any additional setup after loading the view.
    }

    @IBAction func findOnMap(_ sender: Any) {
        guard let locationText = locationLabel.text else {
            print("empty location")
            return
        }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationText, completionHandler: {(placemark, error) in
            guard error == nil else {
                print("err")
                return
            }
            
            guard let showPinController = self.storyboard?.instantiateViewController(withIdentifier: "showPin") as? shareLinkViewController else {
                print("something went wrong")
                return
            }
            
            guard let location = placemark?[0].location?.coordinate else {
                print("location err")
                return
            }
            
            showPinController.pointAnnotation.coordinate = location
            showPinController.pointAnnotation.title = "Mihir Thanekar"  // Get Name from info
            
            DispatchQueue.main.async{
                self.present(showPinController, animated: false, completion: nil)
            }

        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
