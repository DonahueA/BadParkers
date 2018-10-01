//
//  ImageAnnotationView.swift
//  BadParkers
//
//  Created by Donahue Avila on 3/10/18.
//  Copyright © 2018 Donahue Avila. All rights reserved.
//

import MapKit

class ImageAnnotationView: MKAnnotationView {
    
    var url : URL?
    var carImage: UIImage?
    var dataId: String?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        if let annotation = annotation as? ImageAnnotation {
            url = annotation.url
            dataId = annotation.dataId
            
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
        } else {
            fetchImage()
        }
        
        
    }
    
    private func fetchImage() {
        if let url = url {
            DispatchQueue.global(qos: .userInitiated).async {
                [weak self] in let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents, url == self?.url {
                        self?.carImage = UIImage(data: imageData)
                        self?.setNeedsDisplay()
                    }
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    

    
}
