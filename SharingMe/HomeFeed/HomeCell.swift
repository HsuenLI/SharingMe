//
//  HomeCell.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/22.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

protocol HomePostCellDelegate {
    func didTapComment(post : Post)
    func didLike(for cell : HomeCell)
}

class HomeCell : UICollectionViewCell {
    
    var post : Post?{
        didSet{
            guard let imageUrl = post?.imageUrl else {return}
            postImageView.loadImage(urlString: imageUrl)
            
            usernameLabel.text = post?.user.username
            
            guard let profileImageUrl = post?.user.profileImageURL else {return}
            profileImageView.loadImage(urlString: profileImageUrl)
            
            setupAttributedCaption()
        }
    }
    
    var delegate : HomePostCellDelegate?
    
    fileprivate func setupAttributedCaption(){
        
        guard let post = self.post else{return}
        let attributedText = NSMutableAttributedString(string: post.user.username , attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 4)]))
        
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        attributedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14) ]))
        captionLabel.attributedText = attributedText
        
        likeButton.setImage(post.hasLiked == true ? UIImage(named: "like_selected")?.withRenderingMode(.alwaysOriginal) : UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
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
        return label
    }()
    
    let optionsButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.tintColor = UIColor.black
        return button
    }()
    
    let postImageView : CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var likeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLike(){
        delegate?.didLike(for: self)
    }
    
    lazy var commentButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()
    
    @objc func handleComment(){
        guard let post = post else {return}
        delegate?.didTapComment(post : post)
    }
    
    let sendButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "send2")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let bookmarkButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ribbon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let captionLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(postImageView)
        addSubview(optionsButton)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.masksToBounds = true

        usernameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: postImageView.topAnchor, right: optionsButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        optionsButton.anchor(top: topAnchor, left: nil, bottom: postImageView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 44, height: 0)
        
        postImageView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true

        setupActionButton()
        
        addSubview(captionLabel)
        captionLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
    }
    
    
    fileprivate func setupActionButton() {
        let toolStackView = UIStackView(arrangedSubviews: [likeButton,commentButton,sendButton])
        toolStackView.axis = .horizontal
        toolStackView.distribution = .fillEqually
        addSubview(toolStackView)
        toolStackView.anchor(top: postImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 120, height: 50)
        addSubview(bookmarkButton)
        bookmarkButton.anchor(top: postImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 40, height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
