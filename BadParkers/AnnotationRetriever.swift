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
    let storage = Storage.storage()
    let storageRef: StorageReference
    
    
    var mapRegion : MKCoordinateRegion {
        didSet{
            getImageAnnotations()
        }
    }
    
    private(set) var ImageAnnotations : [ImageAnnotation] = []
    
    public func newPost(withCoords coords: CLLocationCoordinate2D, withImage image: UIImage) {
        
        let resizedImage = image.cropToAspect(width: 4, height: 3)
        
        if let data = resizedImage.jpegData(compressionQuality: 0.4), let iconData = image.makeIcon().jpegData(compressionQuality: 1) {
            let uuid = UUID()
            
            let newImageRef = storageRef.child("BadParkers/fullsized/\(uuid).jpg")
            let iconImageRef = storageRef.child("BardParkes/icons/\(uuid).jpg")
            
            //Make smaller image?
            let metaData = StorageMetadata()
            iconImageRef.putData(iconData)
            newImageRef.putData(data, metadata: metaData) { [unowned self](metaData, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "Error uploading file.")
                    
                }else{
                    self.db.collection("photoLocations").addDocument(data: ["location":          GeoPoint(latitude: coords.latitude, longitude: coords.longitude), "URL": newImageRef.fullPath, "ICON": iconImageRef.fullPath])
                    
                    self.getImageAnnotations()
                }
            }
        }
        
    }
        
        
    
    
    private func getImageAnnotations() {
        
        //TODO: Change so we don't grab all locations, instead just those in our view.
        db.collection("photoLocations").getDocuments(completion: {[unowned self] (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in QuerySnapshot!.documents {
                    print(document.documentID)
                    if let coordinates = document.data()["location"] as? GeoPoint, let imageURL = document.data()["ICON"] as? String {
                        let downloadImageRef = self.storageRef.child(imageURL)
                        downloadImageRef.downloadURL(completion: { (url, error) in
                            if let error = error {
                                print(error)
                            }else if let url = url {
                                let newImage = ImageAnnotation(coordinates.CLLocation(), URL(string: url.absoluteString)!, document.documentID)
                                if !self.ImageAnnotations.contains(newImage)
                                {
                                    self.ImageAnnotations.append(newImage)
                                }
                            }
                        })
                        

                        
                    }
                }
                //.
                self.delegate?.annotationsDidChange(annotations: (self.ImageAnnotations))
            }
        })
        
    }
    
    init(with mapRegion: MKCoordinateRegion){
        self.mapRegion = mapRegion
        storageRef = storage.reference()
        getImageAnnotations()
    }
    
}

extension GeoPoint {
    func CLLocation() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
}


extension UIImage {
    func cropToAspect(width: Float, height: Float) -> UIImage {

        var newHeight = self.size.height
        var newWidth = self.size.width
        let currentAspect = newWidth/newHeight
        let newAspect = CGFloat(width/height)
        if currentAspect == newAspect { return self}

        if currentAspect - newAspect > 0 {
            newWidth = newWidth/currentAspect * newAspect
        }else{
            newHeight = newHeight*currentAspect/newAspect
        }
        
        var cropRect : CGRect;
        if self.imageOrientation.rawValue == 3 || self.imageOrientation.rawValue == 2{
            cropRect = CGRect(x: (self.size.height-newHeight)/2, y: 0, width: newHeight, height: newWidth)
        }else{
            cropRect = CGRect(x: (self.size.width-newWidth)/2 , y: 0, width: newWidth, height: newHeight)
            
        }
        let newImage = self.cgImage?.cropping(to: cropRect)
        return UIImage(cgImage: newImage!, scale: self.scale, orientation: self.imageOrientation)
    }
    func makeIcon() -> UIImage {
        
        let imageSize = CGSize(width: 70, height: 70)
        UIGraphicsBeginImageContext(imageSize)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: imageSize))
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}

