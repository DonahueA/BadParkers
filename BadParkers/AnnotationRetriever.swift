//
//  AnnotationRetriever.swift
//  BadParkers
//
//  Created by Donahue Avila on 3/11/18.
//  Copyright © 2018 Donahue Avila. All rights reserved.
//

import Foundation
import MapKit
import Firebase

protocol AnnotationRetrieverDelegate: class {
    
    func annotationsDidChange(annotations: [ImageAnnotation])
}

class AnnotationRetriever {
    
    weak var delegate: AnnotationRetrieverDelegate?
    
    let db = Firestore.firestore()
    
    var mapRegion : MKCoordinateRegion {
        didSet{
            getImageAnnotations()
        }
    }
    
    private(set) var ImageAnnotations : [ImageAnnotation] = []
    
    private func getImageAnnotations() {
        
        //TODO: Make asynchronous if need be
        
        //TODO: Change so we don't grab all locations, instead just those in our view.
        db.collection("photoLocations").getDocuments(completion: {[unowned self] (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in QuerySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    if let coordinates = document.data()["location"] as? GeoPoint {
                        let newImage = ImageAnnotation(coordinates.CLLocation(), URL(string: "https://b.thumbs.redditmedia.com/p_mhrqWy_56i8-oMDS_48XRAybZd2nm-URldx4F6D0c.jpg")!)
                        
                        if !self.ImageAnnotations.contains(newImage)
                        {
                            self.ImageAnnotations.append(newImage)
                        }
                        
                    }
                }
                
                self.delegate?.annotationsDidChange(annotations: (self.ImageAnnotations))
            }
        })
        
    }
    
    init(with mapRegion: MKCoordinateRegion){
        self.mapRegion = mapRegion
        getImageAnnotations()
    }
    
}

extension GeoPoint {
    func CLLocation() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
}
