//
//  Post.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/20.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import Foundation

struct Post {
    let imageUrl : String
    
    
    init(dictionary : [String : Any]) {
        self.imageUrl = dictionary["imageURL"] as? String ?? ""
    }
}
