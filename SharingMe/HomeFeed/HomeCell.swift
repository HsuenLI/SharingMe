//
//  HomeCell.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/22.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class HomeCell : UICollectionViewCell {
    
    var post : Post?{
        didSet{
            guard let imageUrl = post?.imageUrl else {return}
            postImageView.loadImage(urlString: imageUrl)
        }
    }
    
    let postImageView : CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(postImageView)
        postImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
