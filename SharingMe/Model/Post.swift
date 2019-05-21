//
//  Post.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/20.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import Foundation

struct Post {
    var id : String?    
    let imageUrl : String
    let user : User
    let caption : String
    let creationDate : Date
    
    var hasLiked : Bool = false
    var hasBookmark : Bool = false
    
    init(user : User, dictionary : [String : Any]) {
        self.imageUrl = dictionary["imageURL"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        self.user = user
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
