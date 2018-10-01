//
//  ImageAnnotationView.swift
//  BadParkers
//
//  Created by Donahue Avila on 3/10/18.
//  Copyright © 2018 Donahue Avila. All rights reserved.
//

import MapKit
import Firebase

class ImageAnnotationView: MKAnnotationView {
    
    var reference : String?
    var carImage: UIImage? {
        didSet{
            setNeedsDisplay()
        }
    }
    var dataId: String?
    let storage = Storage.storage()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        if let annotation = annotation as? ImageAnnotation {
            reference = annotation.reference
            dataId = annotation.dataId
            let pathReference = storage.reference(withPath: reference!)
            pathReference.getData(maxSize: 1024*1024) { [weak self] (data, error) in
                if error != nil {
                    print("Error downloading image icon")
                } else {
                    self?.carImage = UIImage(data: data!)
                }
            }
        }
        frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        isOpaque = false
        setNeedsDisplay()
    }

    
    //TODO: Image fills instead of clips, could be changed database side?
    override func draw(_ rect: CGRect) {
        
        let roundedRect = UIBezierPath(roundedRect: rect, cornerRadius: 10)
        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setFill()
        roundedRect.fill()

        
        if let drawImage = carImage {
            drawImage.draw(in: rect.insetBy(dx: 5, dy: 5))
        }
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    

    
}
