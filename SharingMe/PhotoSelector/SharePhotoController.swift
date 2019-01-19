//
//  SharePhotoController.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/19.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class SharePhotoController : UIViewController {
    
    //Outlets
    var selectedImage : UIImage?{
        didSet{
            sharePhotoImageView.image = selectedImage
        }
    }
    
    let sharePhotoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let shareTextView : UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 240, green: 240, blue: 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShareButton))
        setupImageAndTextView()
    
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    @objc func handleShareButton(){
        print("share Photo")
    }
    
    fileprivate func setupImageAndTextView(){
        let contrainerView = UIView()
        contrainerView.backgroundColor = .white
        view.addSubview(contrainerView)
        contrainerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        contrainerView.addSubview(sharePhotoImageView)
        sharePhotoImageView.anchor(top: contrainerView.topAnchor, left: contrainerView.leftAnchor, bottom: contrainerView.bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 90)
        
        contrainerView.addSubview(shareTextView)
        shareTextView.anchor(top: contrainerView.topAnchor, left: sharePhotoImageView.rightAnchor, bottom: contrainerView.bottomAnchor, right: contrainerView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 0)
    }
}
