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
    var annotation: MKPointAnnotation? = nil // temp storage for posted point
    
    @IBAction func logout(_ sender: Any) {
        NetworkRequests.deleteSession()
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NetworkRequests.getLocations {
            for locations in Annotations.MapPoints {
                let annot = MKPointAnnotation()
                
                annot.title = "\(locations["firstName"] as? String ?? "") \(locations["lastName"] as? String ?? "")"
                annot.subtitle = locations["mediaURL"] as? String ?? ""
                annot.coordinate = CLLocationCoordinate2D(latitude: locations["latitude"] as? Double ?? 0, longitude: locations["longitude"] as? Double ?? 0)
                
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(annot)
                }
                Annotations.MapAnnotations.append(annot)
            }
            
        }
        
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
}

