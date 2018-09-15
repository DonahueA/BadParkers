//
//  AnnotationViewController.swift
//  BadParkers
//
//  Created by Donahue Avila on 3/10/18.
//  Copyright © 2018 Donahue Avila. All rights reserved.
//

import UIKit
import MapKit

class ImageAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
    init(_ coord: CLLocationCoordinate2D) {
        coordinate = coord
    }
    
    
}
