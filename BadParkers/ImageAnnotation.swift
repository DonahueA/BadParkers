//
//  ImageAnnotation.swift
//  BadParkers
//
//  Created by Donahue Avila on 3/10/18.
//  Copyright © 2018 Donahue Avila. All rights reserved.
//

import Foundation
import MapKit

class ImageAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var url : URL
    var dataId: String
    
    init(_ coordinate: CLLocationCoordinate2D, _ url:URL, _ dataId: String) {
        self.coordinate = coordinate
        self.url = url
        self.dataId = dataId
    }
}
