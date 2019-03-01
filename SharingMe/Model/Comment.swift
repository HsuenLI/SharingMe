//
//  Comment.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/3/2.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import Foundation

struct Comment {
    let  user : User
    let uid : String
    let text : String
    
    init(user : User, dictionary : [String : Any]) {
        self.user = user
        self.uid = dictionary["uid"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
    }
}
