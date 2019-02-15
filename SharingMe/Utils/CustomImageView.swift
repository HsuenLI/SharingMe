//
//  CustomImageView.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/21.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

var imageCache = [String : UIImage]()

class CustomImageView : UIImageView{
    
    var lastURLUsedToLoadImage : String?
    
    func loadImage(urlString : String){
        guard let url = URL(string: urlString) else{return}
        lastURLUsedToLoadImage = urlString
        
        self.image = nil
        
        if let cachedImage = imageCache[urlString]{
            self.image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error{
                print("Failed to fetch post image:", error)
                return
            }
            
            if url.absoluteString != self.lastURLUsedToLoadImage{
                return
            }
            
            guard let imageData = data else {return}
            let photoImage = UIImage(data: imageData)
            
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async{
                self.image = photoImage
            }
            }.resume()
    }
}
