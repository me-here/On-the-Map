//
//  MapViewController.swift
//  maps
//
//  Created by Mihir Thanekar on 7/9/17.
//  Copyright © 2017 Mihir Thanekar. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    //var annotation: MKPointAnnotation? = nil // temp storage for posted point
    
    @IBAction func logout(_ sender: Any) {
        NetworkRequests.deleteSession()
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard Constants.Parse.shouldReloadData else {
            return
        }
        
        let values: [String: String] = [
            Constants.Parse.parameters.AppID: Constants.Parse.values.appID,
            Constants.Parse.parameters.APIKey: Constants.Parse.values.APIKey
        ]
        
        NetworkRequests.requestWith(requestType: Constants.requestType.GET.rawValue, requestURL: Constants.Udacity.studentLocationsURL, addValues: values, httpBody: nil, completionHandler: {(data, error) in
            guard let data = data, error == nil else {
                self.displayError(message: "Pin loading error")
                return
            }
            print(data)
            
            let results = data["results"] as! [[String: AnyObject]]
            _ = model(allPoints: results)
            //Annotations.MapPoints = results
            
            for pinInfo in model.allStudentsInfo {
                let annot = MKPointAnnotation()
                
                annot.title = pinInfo.name
                annot.subtitle = pinInfo.link
                annot.coordinate = pinInfo.location
                
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(annot)
                }
                //Annotations.MapAnnotations.append(annot)
            }
          Constants.Parse.shouldReloadData = false
        })
        print("Reloaded map")
        
    }
    
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.rightCalloutAccessoryView = UIButton(type: .infoLight)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let linkString = view.annotation?.subtitle as? String, !linkString.isEmpty else {
            print("Empty link in pin")
            return
        }
        let link = URL(string: linkString)!
        UIApplication.shared.open(link, options: [:], completionHandler: nil)
        
    }
    
    private func displayError(title:String? = "Download failure",message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(.init(title: "Retry", style: .default, handler: {_ in
            Constants.Parse.shouldReloadData = true
            self.viewWillAppear(true)
        }))
        alert.addAction(.init(title: "Give up", style: .destructive, handler: {_ in
            DispatchQueue.main.async {
                alert.dismiss(animated: true, completion: nil)
            }
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

