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
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        if let annotation = annotation as? ImageAnnotation {
            url = annotation.url
            
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
    
    //TODO: Figure out what to do when selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            setNeedsDisplay()
            print("Selected")
            //load bigger image or prepare for segue
        } else {
            //deselect
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
