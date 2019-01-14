//
//  UserProfileHeaderCell.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/13.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader : UICollectionReusableView {
    
    //Outlets
    var user : User?{
        didSet{
            usernameLabel.text = user?.username
            setupFetchProfileImage()
        }
    }
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
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
    
    let gridButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let listButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "list")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let bookmarkButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = .black
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
    
    let editProfileButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProfileImageView()
        setupUsernameLabel()
        setupBottomToolBar()
        setupStatusBar()
        setupEditProfileButton()
        
        //setupFetchProfileImage()
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
        addSubview(editProfileButton)
        editProfileButton.anchor(top: postsLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 2, paddingLeft: 30, paddingBottom: 0, paddingRight: 12, width: 0, height: 34)
    }
    
    fileprivate func setupFetchProfileImage(){
        guard let profileImageUrl = user?.profileImageURL else {return}
        guard let url = URL(string: profileImageUrl) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error{
                print("Failed to load profile image url: ", err)
            }
            guard let imageData = data else {return}
            DispatchQueue.main.async {
                self.profileImageView.image = UIImage(data: imageData)
            }
            }.resume()
    }
}

