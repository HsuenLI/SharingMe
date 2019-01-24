//
//  SearchController.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/25.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class UserSearchController : UICollectionViewController{
    
    //Outlets
    let cellId = "cellId"
    let searhBar : UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor(red: 230, green: 230, blue: 230)
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
        
        navigationController?.navigationBar.addSubview(searhBar)
        guard let navigationBar = navigationController?.navigationBar else {return}
        searhBar.anchor(top: navigationBar.topAnchor, left: navigationBar.leftAnchor, bottom: navigationBar.bottomAnchor, right: navigationBar.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }
}

extension UserSearchController : UICollectionViewDelegateFlowLayout{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
}
