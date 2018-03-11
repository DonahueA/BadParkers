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
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        if let annotation = annotation as? ImageAnnotation {
            url = annotation.url
        }
        
        frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        backgroundColor = UIColor.blue
        fetchImage()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
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
                        print("Yes")
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
