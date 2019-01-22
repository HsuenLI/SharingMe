//
//  CustomImageView.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/21.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class CustomImageView : UIImageView{
    
    var lastURLUsedToLoadImage : String?
    
    func loadImage(urlString : String){
        guard let url = URL(string: urlString) else{return}
        lastURLUsedToLoadImage = urlString
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error{
                print("Failed to fetch post image:", error)
                return
            }
            
            if url.absoluteString != self.lastURLUsedToLoadImage{
                return
            }
            
            DispatchQueue.main.async{
                guard let imageData = data else {return}
                self.image = UIImage(data: imageData)
            }
            }.resume()
    }
}
