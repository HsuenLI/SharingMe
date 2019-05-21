//
//  UserProfileController.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/13.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController : UICollectionViewController {
    
    //Outlets
    let cellId = "cellId"
    let headerId = "headerId"
    let homePostCellId = "homePostCellId"
    var user : User?
    var posts = [Post]()
    var userId : String?
    var isGridView = true
    var isBookmark = false
    var bookmarkPost = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: homePostCellId)

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear"), style: .plain, target: self, action: #selector(handleGearButton))
        navigationController?.navigationBar.tintColor = UIColor.darkGray
        fetchUser()
        fetchBookmarkPost()
        //fetchOrderedPosts()
    }
    
    fileprivate func fetchUser(){
        
        let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
        
        //guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = self.user?.username
            self.collectionView.reloadData()
            
            self.fetchOrderedPosts()
        }
    }
    
    fileprivate func fetchOrderedPosts(){
        guard let uid = self.user?.uid else {return}
        let ref = Database.database().reference().child("posts").child(uid)
        
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            
            guard let user = self.user else {return}
            let post = Post(user: user, dictionary: dictionary)
            
            self.posts.insert(post, at: 0)
            self.collectionView.reloadData()
        }) { (error) in
            print("Failed to fetch posts from database: ", error)
        }
    }
    
    
    @objc func handleGearButton(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Log Out", style: .default) { (action) in
            do {
                try Auth.auth().signOut()
                
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController,animated: true)
            }catch let error{
                print("Failed to sign out from firebase:" , error)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        present(alert,animated: true)
    }
    
}

extension UserProfileController : UICollectionViewDelegateFlowLayout{
    
    //Collection view header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserProfileHeader
        
        header.user = self.user
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 175)
    }
    
    //Collection view cell
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isBookmark{
            return bookmarkPost.count
        }
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isGridView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
            cell.post = posts[indexPath.item]
            return cell
        }
        if isBookmark{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellId, for: indexPath) as! HomeCell
            cell.post = bookmarkPost[indexPath.item]
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellId, for: indexPath) as! HomeCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGridView{
            let width = (view.frame.width - 2) / 3
            return CGSize(width: width, height: width)
        }
        let width = view.frame.width
        var height : CGFloat = 40 + 8 + 8 //userprofile + top + bottom space
        height += width
        height += 50 //action buttons
        height += 60 //caption text
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension UserProfileController : UserProfileHeaderDelegate{
    
    func didChangeToListView() {
        isGridView = false
        isBookmark = false
        collectionView.reloadData()
    }
    
    func didChangeToGridView() {
        isGridView = true
        isBookmark = false
        collectionView.reloadData()
    }
    
    func didChangeToBookmarkView() {
        isBookmark = true
        isGridView = false
        collectionView.reloadData()
    }
    
    fileprivate func fetchBookmarkPost(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("bookmarks").observe(.value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            dictionary.forEach({ (postId, value) in
                guard let userLikeDictionary = value as? [String : Int] else {return}
                userLikeDictionary.forEach({ (userId, mark) in
                    if userId == uid && mark == 1{
                        self.fetchPostWithPostId(postId: postId)
                    }
                })
            })
        }) { (error) in
            print("failed to fetch likes post in database: ", error)
        }
    }
    
    fileprivate func fetchPostWithPostId(postId : String){
        Database.database().reference().child("posts").observe(.value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            dictionary.forEach({ (userId, post) in
                guard let posts = post as? [String : Any] else {return}
                posts.forEach({ (postKey, post) in
                    if postKey == postId{
                        Database.fetchUserWithUID(uid: userId, completion: { (user) in
                            self.bookmarkPost.append(Post(user: user, dictionary: post as! [String : Any]))
                            self.collectionView.reloadData()
                        })
                    }
                })
            })
        }) { (error) in
            print("failed to fetch likes post in database: ", error)
        }
    }
}

