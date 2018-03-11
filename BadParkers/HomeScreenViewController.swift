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
    
    private lazy var annotationGetter = AnnotationRetriever(with: MapView.region)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        MapView.delegate = self
        if let center = locationManager.location?.coordinate {
            MapView.setRegion(MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)), animated: false)
        }
        annotationGetter.delegate = self
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
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(mapView.centerCoordinate)
    }

    
}

extension HomeScreenViewController: AnnotationRetrieverDelegate {
    func annotationsDidChange(annotations: [ImageAnnotation]) {
        for annotation in annotations {
            MapView.addAnnotation(annotation)
        }
    }
    
    
    
}
