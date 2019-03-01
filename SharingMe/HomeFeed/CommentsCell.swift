//
//  CommentsCell.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/3/2.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class CommentsCell : UICollectionViewCell{
    
    var comment : Comment?{
        didSet{
            guard let username = comment?.user.username else {return}
            let attributedString = NSMutableAttributedString(string: username, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])

            guard let text = comment?.text else {return}
            attributedString.append(NSAttributedString(string: " " + text, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
            
            commentText.attributedText = attributedString
            guard let imageUrl = comment?.user.profileImageURL else {return}
            profileImageView.loadImage(urlString: imageUrl)
        }
    }
    
    let profileImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let commentText : UITextView = {
        let textView = UITextView()
        textView.text = "comments"
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .black
        textView.isScrollEnabled = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 5, paddingRight: 0, width: 40, height: 40)
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.masksToBounds = true
        
        addSubview(commentText)
        commentText.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        addSubview(separatorView)
        separatorView.anchor(top: nil, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
