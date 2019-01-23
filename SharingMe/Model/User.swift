//
//  User.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/24.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import Foundation

struct User{
    let username : String
    let profileImageURL : String
    
    init(dictionary : [String : Any]){
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
    }
}
