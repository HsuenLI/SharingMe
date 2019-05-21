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
    
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateNotificationName, object: nil)
        collectionView.backgroundColor = .white
        setupNavigationItems()
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchAllPosts()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc func handleUpdateFeed(){
        handleRefresh()
    }
    
    @objc func handleRefresh(){
        posts.removeAll()
        fetchAllPosts()
    }
    
    fileprivate func fetchAllPosts() {
        //fetchPosts()
        fetchFollowingUserIds()
    }
    
    fileprivate func fetchFollowingUserIds(){
        guard let uid = Auth.auth().currentUser?.uid else  {return}
        let ref = Database.database().reference().child("following").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            self.collectionView.refreshControl?.endRefreshing()
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera3")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
    }
    
    @objc func handleCamera(){
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
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
            
//            var snapshotKeys = [String]()
//            for key in dictionaries.keys{
//                snapshotKeys.append(key)
//            }
//            snapshotKeys.sort()
            
//            for snapshotKey in snapshotKeys{
//                print("snapshotKey: \(snapshotKey)")
//                guard let dictionary = dictionaries[snapshotKey] as? [String : Any] else {return}
//                var post = Post(user: user, dictionary: dictionary)
//                post.id = snapshotKey
//                self.posts.insert(post, at: 0)
//            }
            
            dictionaries.forEach({ (key, value) in
                print("snapshotKey: \(key)")
                guard let dictionary = dictionaries[key] as? [String : Any] else {return}
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                guard let uid = Auth.auth().currentUser?.uid else {return}
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let values = snapshot.value as? Int, values == 1 {
                        post.hasLiked = true
                    }else {
                        post.hasLiked = false
                    }
                    self.posts.insert(post, at: 0)
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    self.collectionView.reloadData()
                }, withCancel: { (error) in
                    print("Failed to observe likes :", error)
                })
                
                Database.database().reference().child("bookmarks").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let values = snapshot.value as? Int, values == 1 {
                        post.hasBookmark = true
                    }else {
                        post.hasBookmark = false
                    }
                    self.posts.insert(post, at: 0)
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    self.collectionView.reloadData()
                }, withCancel: { (error) in
                    print("Failed to observe likes :", error)
                })

            })
            
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
        
        if indexPath.item < posts.count{
            cell.post = posts[indexPath.item]
            cell.delegate = self
        }
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

extension HomeController : HomePostCellDelegate{
    func didLike(for cell: HomeCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        var post = posts[indexPath.item]
        post.hasLiked = !post.hasLiked
        guard let postId = post.id else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let values = [uid : post.hasLiked == true ? 1 : 0]
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { (error, reference) in
            if let error = error{
                print("Failed to update like in database : ", error)
                return
            }
            self.posts[indexPath.item] = post
            self.collectionView.reloadItems(at: [indexPath])
            print("Update like in database successfully.")
        }
    }
    
    func didTapComment(post : Post) {
        let layout = UICollectionViewFlowLayout()
        let commentsController = CommentsController(collectionViewLayout : layout)
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    func didTapBookmark(for cell: HomeCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        var post = posts[indexPath.item]
        post.hasBookmark = !post.hasBookmark
        guard let postId = post.id else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let values = [uid : post.hasBookmark == true ? 1 : 0]
        Database.database().reference().child("bookmarks").child(postId).updateChildValues(values) { (error, reference) in
            if let error = error{
                print("Failed to update like in database : ", error)
                return
            }
            self.posts[indexPath.item] = post
            self.collectionView.reloadItems(at: [indexPath])
            print("Update like in database successfully.")
        }
    }
}
