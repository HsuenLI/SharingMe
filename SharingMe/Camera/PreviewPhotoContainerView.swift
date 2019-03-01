//
//  PreviewPhotoContainerView.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/2/24.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView : UIView{
    
    let previewImageView : UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "cancel_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    @objc func handleCancel(){
        self.removeFromSuperview()
    }
    
    let saveButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "save_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSave(){
        
        guard let image = self.previewImageView.image else {return}
        let libary = PHPhotoLibrary.shared()
        libary.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)

            
        }) { (success, err) in
            if let err = err{
                print("Failed to save photo into photo library: ", err)
            }
            
            print("Success save photo into photo library")
            
            DispatchQueue.main.async {
                let saveLabel = UILabel()
                saveLabel.text = "Saved Successfully"
                saveLabel.textColor = .white
                saveLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                saveLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                saveLabel.center = self.center
                saveLabel.font = UIFont.boldSystemFont(ofSize: 14)
                saveLabel.textAlignment = .center
                saveLabel.numberOfLines = 0
                self.addSubview(saveLabel)
                
                saveLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    saveLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                }, completion: { (completed) in
                    UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        saveLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        saveLabel.alpha = 0
                    }, completion: { (_) in
                        saveLabel.removeFromSuperview()
                    })
                })
            }

        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(previewImageView)
        previewImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 00, height: 0)
        addSubview(cancelButton)
        cancelButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        addSubview(saveButton)
        saveButton.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 24, paddingBottom: 24, paddingRight: 0, width: 50, height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
