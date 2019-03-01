//
//  CommentsController.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/3/1.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit
import Firebase

class CommentsController : UICollectionViewController{
    
    var post : Post?
    let cellId = "cellId"
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        navigationItem.title = "Comments"
        navigationController?.navigationBar.tintColor = .darkGray
        
        collectionView.register(CommentsCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        fetchComments()
    }
    
    fileprivate func fetchComments(){
        guard let postId = post?.id else {return}
        let ref = Database.database().reference().child("comments").child(postId)
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            
            Database.fetchUserWithUID(uid: uid, completion: { (user) in
                let comment = Comment(user : user, dictionary: dictionary)
                self.comments.append(comment)
                
                self.collectionView.reloadData()
            })
            
        }) { (err) in
            print("Failed to fetch comments from database:", err)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    let commentTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Comments"
        return tf
    }()
    
    lazy var containerView : UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Send", for: .normal)
        submitButton.setTitleColor(UIColor.blue, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.addTarget(self, action: #selector(handleSendButton), for: .touchUpInside)
        containerView.addSubview(submitButton)
        submitButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
        

        containerView.addSubview(commentTextField)
        commentTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
        
        let lineSeparoaterView = UIView()
        lineSeparoaterView.backgroundColor = .lightGray
        containerView.addSubview(lineSeparoaterView)
        lineSeparoaterView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        return containerView
    }()
    
    @objc func handleSendButton(){
        guard let postId = post?.id else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let values = ["text" : commentTextField.text ?? "", "creationDate" : Date().timeIntervalSince1970, "uid" : uid] as [String : Any]
        let databaseRef = Database.database().reference().child("comments").child(postId)
        databaseRef.childByAutoId().updateChildValues(values) { (error, reference) in
            if let error = error{
                print("Failed to updata comments in database: ", error)
                return
            }
            
            print("Updata comments suscessfully. ")
        }
    }
    
    override var inputAccessoryView: UIView?{
        get{
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
}

extension CommentsController : UICollectionViewDelegateFlowLayout{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentsCell
        cell.comment = comments[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let frame = CGRect(x: 0, y: 0, width: width, height: 50)
        let dummyCell = CommentsCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        let targetSize = CGSize(width: width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
