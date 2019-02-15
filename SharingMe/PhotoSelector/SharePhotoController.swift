//
//  SharePhotoController.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/19.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController : UIViewController {
    
    //Outlets
    static let updateNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
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
        guard let image = selectedImage else {return}
        guard let caption = shareTextView.text, caption.count > 0 else {return}
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else {return}
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("posts").child(filename)
        storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
            if let error = error{
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload share image: ", error)
                return
            }
            storageRef.downloadURL { (downloadURL, error) in
                if let error = error{
                    print("Failed to get url from firebase:" , error)
                    return
                }
                guard let shareURL = downloadURL?.absoluteString else {return}
                print("Successfully uploaded post image:" , shareURL)
                
                self.saveToDatabaseWithImageUrl(imageUrl: shareURL)
            }

        }
    }
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl : String){
        guard let postImage = selectedImage else {return}
        guard let caption = shareTextView.text else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        let values = ["imageURL" : imageUrl, "caption" : caption, "imageWidth" : postImage.size.width, "imageHeight" : postImage.size.height, "creationDate" : Date().timeIntervalSince1970] as [String : Any]
        
        ref.updateChildValues(values) { (error, ref) in
            if let error = error{
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload image url into database: ", error)
                return
            }
            print("Successfully saved post to database")
            self.dismiss(animated: true, completion: nil)
        
            NotificationCenter.default.post(name: SharePhotoController.updateNotificationName, object: nil)
        }
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
