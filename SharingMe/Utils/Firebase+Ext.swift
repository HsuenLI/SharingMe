//
//  Firebase+Ext.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/24.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit
import Firebase

extension Database{
    static func fetchUserWithUID(uid : String, completion : @escaping (User) -> ()){
        let userRef = Database.database().reference().child("users").child(uid)
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String : Any] else {return}
            //let user = User(uid: uid, dictionary: userDictionary)
            
            //completion(user)
            
        }) { (error) in
            print("Failed to fetch post's user data from database: ", error)
        }
    }
}
