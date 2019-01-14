//
//  MainTabBarController.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/13.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController : UITabBarController, UITabBarControllerDelegate {
    
    //Disable select tab bar item
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.index(of: viewController)
        if index == 2{
            let photoSelectorController = PhotoSelectorController(collectionViewLayout : UICollectionViewFlowLayout())
            let photoSelectorNavController = UINavigationController(rootViewController: photoSelectorController)
            present(photoSelectorNavController,animated: true)
            return false
        }
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.delegate = self
        DispatchQueue.main.async {
            if Auth.auth().currentUser == nil{
                let loginController = LoginController()
                let loginNavController = UINavigationController(rootViewController: loginController)
                self.present(loginNavController,animated: true)
                return
            }
        }
        setupControllers()
    }
    
    func setupControllers(){
        
        let homeController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        let homeNavController = customControllers(viewController: nil, collectionView: homeController, selectedImage: "home_selected", unselectedImage: "home_unselected")
        
        let searchController = UICollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let searchNavController = customControllers(viewController: nil, collectionView: searchController, selectedImage: "search_selected", unselectedImage: "search_unselected")
        
        let plusController = UIViewController()
        let plusNavController = customControllers(viewController: plusController, collectionView: nil, selectedImage: "plus_unselected", unselectedImage: "plus_unselected")
        
        let likeController = UICollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let likeNavController = customControllers(viewController: nil, collectionView: likeController, selectedImage: "like_selected", unselectedImage: "like_unselected")
        
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        let userProfileNavController = customControllers(viewController: nil, collectionView: userProfileController, selectedImage: "profile_selected", unselectedImage: "profile_unselected")
        
        viewControllers = [homeNavController,searchNavController,plusNavController,likeNavController,userProfileNavController]
        tabBar.tintColor = UIColor.darkGray
        //Modify images insets
        guard let items = tabBar.items else {return}
        for item in items{
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    
    fileprivate func customControllers(viewController : UIViewController? , collectionView : UICollectionViewController?, selectedImage : String, unselectedImage : String) -> UINavigationController{
        var navController : UINavigationController?

        if let view = viewController{
            navController = UINavigationController(rootViewController: view)
            view.tabBarItem.image = UIImage(named: unselectedImage)
            view.tabBarItem.selectedImage = UIImage(named: selectedImage)
        }
        
        if let collectionView = collectionView{
            navController = UINavigationController(rootViewController: collectionView)
            collectionView.tabBarItem.image = UIImage(named: unselectedImage)
            collectionView.tabBarItem.selectedImage = UIImage(named: selectedImage)
        }

        return navController!
    }
    
}
