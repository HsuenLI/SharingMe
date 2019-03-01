//
//  CommentsController.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/3/1.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class CommentsController : UICollectionViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        navigationItem.title = "Comments"
        navigationController?.navigationBar.tintColor = .darkGray
        navigationItem.backBarButtonItem?.title = " "
    }
}
