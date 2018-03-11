//
//  HomeScreenViewController.swift
//  BadParkers
//
//  Created by Donahue Avila on 3/10/18.
//  Copyright © 2018 Donahue Avila. All rights reserved.
//

import UIKit
import MapKit

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var MapView: MKMapView!
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        MapView.delegate = self
        MapView.setRegion(MKCoordinateRegion(center: (locationManager.location?.coordinate)!, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)), animated: false)
        
        let newAnnotation = ImageAnnotation((locationManager.location?.coordinate)!, URL(string: "https://b.thumbs.redditmedia.com/p_mhrqWy_56i8-oMDS_48XRAybZd2nm-URldx4F6D0c.jpg")!)
        MapView.addAnnotation(newAnnotation)
    }
    
}

extension HomeScreenViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? ImageAnnotation else {return nil}
        
        let identifier = "ImageMarker"
        var view : ImageAnnotationView
        
        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: "ImageMarker") as? ImageAnnotationView {
            dequedView.annotation = annotation
            view = dequedView
        }else{
            view = ImageAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        return view
    }
}
