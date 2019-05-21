//
//  UserProfileHeaderCell.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/13.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileHeaderDelegate {
    func didChangeToListView()
    func didChangeToGridView()
}

class UserProfileHeader : UICollectionReusableView {
    
    var delegate : UserProfileHeaderDelegate?
    //Outlets
    var user : User?{
        didSet{
            usernameLabel.text = user?.username
            guard let profileImageUrl = user?.profileImageURL else {return}
            profileImageView.loadImage(urlString: profileImageUrl)
            
            setupEditFollowButton()
        }
    }
    
    fileprivate func setupEditFollowButton(){
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else {return}
        guard let userId = user?.uid else {return}
        
        if currentLoggedInUserId == userId{
            
        }else{
            //Check if following
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                if let isFollowing = snapshot.value as? Int, isFollowing == 1{
                    self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                }else{
                    self.setupFollowStyle()
                }
            }) { (error) in
                print("Failed to fetch following user in database : " , error)
            }
        }
    }
    
    
    @objc func handleEditProfileOrFollow(){
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else {return}
        guard let userId = user?.uid else {return}
        let ref = Database.database().reference().child("following").child(currentLoggedInUserId)
        //unfollow someone
        if editProfileFollowButton.titleLabel?.text == "Unfollow" {
            ref.child(userId).removeValue { (error, ref) in
                if let error = error{
                    print("Failed to remove user value in database: ", error)
                    return
                }
                print("Successfully unfollowed user:" , self.user?.username ?? "")
                self.setupFollowStyle()
            }
        }else{
            //Follow someone
            let values = [userId : 1]
            
            ref.updateChildValues(values) { (error, ref) in
                if let error = error{
                    print("Failed to update follow user in database: ", error)
                    return
                }
                print("Successfully follew user: ", self.user?.username ?? "")
                self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                self.editProfileFollowButton.backgroundColor = .white
                self.editProfileFollowButton.setTitleColor(.black, for: .normal)
            }
        }

    }
    
    fileprivate func setupFollowStyle() {
        self.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.editProfileFollowButton.backgroundColor = UIColor(red: 255, green: 137, blue: 35)
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)
        self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    let profileImageView : CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let usernameLabel : UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var gridButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid"), for: .normal)
        button.tintColor = UIColor.mainColor()
        button.addTarget(self, action: #selector(handleGridView), for: .touchUpInside)
        return button
    }()
    
    @objc func handleGridView(){
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
        gridButton.tintColor = UIColor.mainColor()
        delegate?.didChangeToGridView()
    }
    
    
    lazy var listButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.3)
        button.addTarget(self, action: #selector(handleChangeToListView), for: .touchUpInside)
        return button
    }()
    
    @objc func handleChangeToListView(){
        print("tap")
        listButton.tintColor = UIColor.mainColor()
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToListView()
    }
    
    let bookmarkButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.3)
        return button
    }()
    
    let postsLabel : UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: "posts", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let follewersLabel : UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: "follewers", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let followingLabel : UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: "following", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var editProfileFollowButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProfileImageView()
        setupUsernameLabel()
        setupBottomToolBar()
        setupStatusBar()
        setupEditProfileButton()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//Outlets Settle
extension UserProfileHeader{
    
    fileprivate func setupProfileImageView() {
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.layer.masksToBounds = true
    }
    
    fileprivate func setupUsernameLabel(){
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        usernameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
    }
    
    fileprivate func setupBottomToolBar(){
        let topSeparatorView = UIView()
        topSeparatorView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        let toolBarStackView = UIStackView(arrangedSubviews: [gridButton,listButton,bookmarkButton])
        toolBarStackView.distribution = .fillEqually
        toolBarStackView.axis = .horizontal
        
        let bottomSeparatorView = UIView()
        bottomSeparatorView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        addSubview(topSeparatorView)
        addSubview(toolBarStackView)
        addSubview(bottomSeparatorView)
        
        toolBarStackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        topSeparatorView.anchor(top: toolBarStackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        bottomSeparatorView.anchor(top: nil, left: leftAnchor, bottom: toolBarStackView.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    fileprivate func setupStatusBar(){
        let statusStackView = UIStackView(arrangedSubviews: [postsLabel,follewersLabel,followingLabel])
        addSubview(statusStackView)
        statusStackView.distribution = .fillEqually
        statusStackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 12, paddingRight: 0, width: 0, height: 50)
    }
    
    fileprivate func setupEditProfileButton(){
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: postsLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 2, paddingLeft: 30, paddingBottom: 0, paddingRight: 12, width: 0, height: 34)
    }
    
}

