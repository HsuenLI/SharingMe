//
//  UserProfilePhotoCell.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/20.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class UserProfilePhotoCell : UICollectionViewCell{
    
    var post : Post?{
        didSet{
            guard let imageUrl = post?.imageUrl else {return}
            guard let url = URL(string: imageUrl) else{return}
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error{
                    print("Failed to fetch post image:", error)
                    return
                }
                
                if url.absoluteString != self.post?.imageUrl{
                    return
                }
                
                DispatchQueue.main.async{
                    guard let imageData = data else {return}
                    self.photoImageView.image = UIImage(data: imageData)
                }
            }.resume()
        }
    }
    
    let photoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
