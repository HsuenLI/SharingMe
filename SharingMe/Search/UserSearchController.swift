//
//  SearchController.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/25.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController : UICollectionViewController, UISearchBarDelegate{
    
    //Outlets
    let cellId = "cellId"
    lazy var searhBar : UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor(red: 230, green: 230, blue: 230)
        sb.delegate = self
        return sb
    }()
    var users = [User]()
    var filterUsers = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        
        navigationController?.navigationBar.addSubview(searhBar)
        guard let navigationBar = navigationController?.navigationBar else {return}
        searhBar.anchor(top: navigationBar.topAnchor, left: navigationBar.leftAnchor, bottom: navigationBar.bottomAnchor, right: navigationBar.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searhBar.isHidden = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.isEmpty{
            filterUsers = users
        }else{
            filterUsers = self.users.filter { (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            }
        }
        
        collectionView.reloadData()
    }
    
    fileprivate func fetchUsers(){
        let userRef = Database.database().reference().child("users")
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String : Any] else {return}
            dictionaries.forEach({ (uid,value) in
                
                if uid == Auth.auth().currentUser?.uid{
                    return
                }
                guard let dictionary = value as? [String : Any] else {return}
                
                let user = User(uid: uid, dictionary: dictionary)
                self.users.append(user)
            })
            
            self.users.sort(by: { (user1, user2) -> Bool in
                return user1.username.compare(user2.username) == .orderedAscending
            })
            
            self.filterUsers = self.users
            self.collectionView.reloadData()
        }) { (error) in
            print("Failed to fetch user for search: ", error)
        }
    }
}

extension UserSearchController : UICollectionViewDelegateFlowLayout{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        cell.user = filterUsers[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = filterUsers[indexPath.item]
        
        searhBar.isHidden = true
        searhBar.resignFirstResponder()
        let userProfileController = UserProfileController(collectionViewLayout : UICollectionViewFlowLayout())
        userProfileController.userId = user.uid
        navigationController?.pushViewController(userProfileController, animated: true)
    }
}
