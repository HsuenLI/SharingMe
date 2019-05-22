//
//  LikeController.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/5/22.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit
import Firebase

class LikeController : UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    let cellId = "cellId"
    var likes = [Like]()
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
        navigationItem.title = "Like Posts"
         NotificationCenter.default.addObserver(self, selector: #selector(handleLikesUpdate), name:HomeController.likesNotificationName, object: nil)
        fetchAllPosts()
    }
    
    @objc func handleLikesUpdate(){
        fetchAllPosts()
    }
    
    fileprivate func fetchAllPosts(){
        likes.removeAll()
        posts.removeAll()
        fetchLikePost()
        collectionView.reloadData()
    }
    
    fileprivate func fetchLikePost(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("likes").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            dictionary.forEach({ (postId, value) in
                guard let userLikeDictionary = value as? [String : Int] else {return}
                userLikeDictionary.forEach({ (userId, like) in
                    if userId == uid && like == 1{
                        self.fetchPostWithPostId(postId: postId)
                    }
                })
            })
        }) { (error) in
            print("failed to fetch likes post in database: ", error)
        }

    }
    
    fileprivate func fetchPostWithPostId(postId : String){
        Database.database().reference().child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            dictionary.forEach({ (userId, post) in
                guard let posts = post as? [String : Any] else {return}
                posts.forEach({ (postKey, post) in
                    if postKey == postId{
                        Database.fetchUserWithUID(uid: userId, completion: { (user) in
                            self.posts.insert(Post(user: user, dictionary: post as! [String : Any]), at: 0)
                            self.posts.sort(by: { (p1, p2) -> Bool in
                                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                            })
                            self.collectionView.reloadData()
                        })
                    }
                })
            })
        }) { (error) in
            print("failed to fetch likes post in database: ", error)
        }
    }
    
    init(){
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LikeController{
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
