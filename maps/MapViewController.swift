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
   /* override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.mapView.addAnnotations(Annotations.pointsIAdded)
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NetworkRequests.getLocations {
            for locations in Annotations.MapPoints {
                //print(locations)
                /*guard locations["longitude"] as? Double != nil else{
                    continue
                }*/
                let annot = MKPointAnnotation()
                
                annot.title = "\(locations["firstName"] as? String ?? "") \(locations["lastName"] as? String ?? "")"
                annot.subtitle = locations["mediaURL"] as? String ?? ""
                annot.coordinate = CLLocationCoordinate2D(latitude: locations["latitude"] as? Double ?? 0, longitude: locations["longitude"] as? Double ?? 0)
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(annot)
                }
                Annotations.MapAnnotations.append(annot)
                //Annotations.shouldReloadData = false
            }

    }
    
    }
    
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("hoo")
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("aa")
    }
    
    //    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    //        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annot")
    //        if annotationView == nil {
    //            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "annot")
    //            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    //        }
    //        annotationView?.isEnabled = true
    //        annotationView?.canShowCallout = true
    //        return annotationView
    //    }
    
    
    
}

