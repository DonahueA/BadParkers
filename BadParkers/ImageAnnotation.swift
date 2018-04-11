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
    
    init(_ coordinate: CLLocationCoordinate2D, _ url:URL) {
        self.coordinate = coordinate
        self.url = url
    }
}
