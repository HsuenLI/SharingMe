//
//  PhotoSelectorController.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/14.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorController : UICollectionViewController {
    
    //Outlets
    let cellId = "cellId"
    let headerId = "headerId"
    var photos = [UIImage]()
    var selectedImage : UIImage?
    var assets = [PHAsset]()
    var header : PhotoSelectorHeader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
        setupNavigationButtons()
        
        fetchPhotos()
    }
}

//Handle fetch photo
extension PhotoSelectorController{
    
    fileprivate func assestFetchOptions() -> PHFetchOptions{
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 30
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
    
    fileprivate func fetchPhotos(){
        let allPhotos = PHAsset.fetchAssets(with: .image, options: assestFetchOptions())
        
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects { (asset, count, stop) in
                
                //print(count)
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    
                    if let image = image{
                        self.photos.append(image)
                        self.assets.append(asset)
                        
                        //Showing first photo
                        if self.selectedImage == nil{
                            self.selectedImage = image
                        }
                    }
                    
                    if count == allPhotos.count - 1{
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                })
            }
        }
    }
}

//Navigation setting and handle buttons
extension PhotoSelectorController{
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    fileprivate func setupNavigationButtons(){
        navigationController?.navigationBar.tintColor = UIColor.darkGray
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNextButton))
    }
    
    @objc func handleCancelButton(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNextButton(){
        let sharePhotoController = SharePhotoController()
        navigationController?.pushViewController(sharePhotoController, animated: true)
        sharePhotoController.selectedImage = header?.photoImageView.image
    }
}

extension PhotoSelectorController : UICollectionViewDelegateFlowLayout{
    //Header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PhotoSelectorHeader
        self.header = header
        
        if let selectedImage = selectedImage{
            if let index = self.photos.index(of: selectedImage){
                let selectedAsset = self.assets[index]
                let targerSize = CGSize(width: 600, height: 600)
                let imageManager = PHImageManager.default()
                imageManager.requestImage(for: selectedAsset, targetSize: targerSize, contentMode: .default, options: nil) { (image, info) in
                    header.photoImageView.image = image
                    
                }
            }
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    //Cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoSelectorCell
        cell.photoImageView.image = photos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = photos[indexPath.item]
        collectionView.reloadData()
        
        //Selected and back to top
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
}

