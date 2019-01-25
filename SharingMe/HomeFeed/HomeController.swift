//
//  HomeController.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/22.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit
import Firebase

class HomeController : UICollectionViewController {
    
    var cellId = "cellId"
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        setupNavigationItems()
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchPosts()
        
        fetchFollowingUserIds()
    }
    
    fileprivate func fetchFollowingUserIds(){
        guard let uid = Auth.auth().currentUser?.uid else  {return}
        let ref = Database.database().reference().child("following").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdsDictionary = snapshot.value as? [String : Any] else {return}
            
            userIdsDictionary.forEach({ (key, value) in
                Database.fetchUserWithUID(uid: key, completion: { (user) in
                    self.fetchPostsWithUser(user: user)
                })
            })
        }) { (error) in
            print("Failed to fetch following user ids: ", error)
        }
    }
    
    fileprivate func setupNavigationItems(){
        let navigationTitleView = UIImageView(image: UIImage(named: "logo_black"))
        navigationItem.titleView = navigationTitleView
    }
    
    fileprivate func fetchPosts(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
    
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }
    }
    
    fileprivate func fetchPostsWithUser(user : User){
        let postRef = Database.database().reference().child("posts").child(user.uid)
        
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionaries = snapshot.value as? [String : Any] else {return}
            
            var snapshotKeys = [String]()
            for key in dictionaries.keys{
                snapshotKeys.append(key)
            }
            snapshotKeys.sort()
            
            for snapshotKey in snapshotKeys{
                print("snapshotKey: \(snapshotKey)")
                guard let dictionary = dictionaries[snapshotKey] as? [String : Any] else {return}
                let post = Post(user: user, dictionary: dictionary)
                
                self.posts.insert(post, at: 0)
            }
            
            self.collectionView.reloadData()
            
        }) { (error) in
            print("Failed to fetch posts from database: ", error)
        }
    }
}

extension HomeController : UICollectionViewDelegateFlowLayout{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        
        var height : CGFloat = 40 + 8 + 8 //userprofile + top + bottom space
        height += width
        height += 50 //action buttons
        height += 60 //caption text
        return CGSize(width: width, height: height)
    }
}
