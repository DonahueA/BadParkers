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
    @IBOutlet var cameraButton: UIImageView!
    let locationManager = CLLocationManager()
    
    private lazy var annotationGetter = AnnotationRetriever(with: MapView.region)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        MapView.delegate = self
        if let center = locationManager.location?.coordinate {
            MapView.setRegion(MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)), animated: false)
        }
        
        let press = UITapGestureRecognizer(target: self, action: #selector(openCamera))
        
        cameraButton.addGestureRecognizer(press)
        
        annotationGetter.delegate = self
        
    }
    
    @objc func openCamera() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "commentView", let cvc = segue.destination as? CommentViewController {
            if let dataId = (sender as? ImageAnnotationView)?.dataId {
                
                cvc.dataId = dataId
            }
        }
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        performSegue(withIdentifier: "commentView", sender: view)
    }
    
    
    //Useless since annotaitonGetter grabs all, not dependent on current region
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated:
//        annotationGetter.mapRegion = mapView.region
//    }

    
}

extension HomeScreenViewController: AnnotationRetrieverDelegate {
    func annotationsDidChange(annotations: [ImageAnnotation]) {
        for annotation in annotations {
            MapView.addAnnotation(annotation)
        }
    }
    //TODO: Remove Excess Annotations
    
}

extension HomeScreenViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        dismiss(animated: true, completion: nil)
    }
}
