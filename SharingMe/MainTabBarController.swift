//
//  MainTabBarController.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/13.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

class MainTabBarController : UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let homeController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        homeController.tabBarItem.image = UIImage(named: "home_unselected")
        homeController.tabBarItem.selectedImage = UIImage(named: "home_selected")
        let homeNavController = UINavigationController(rootViewController: homeController)
        
        let searchController = UICollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        searchController.tabBarItem.image = UIImage(named: "search_unselected")
        searchController.tabBarItem.selectedImage = UIImage(named: "search_selected")
        let searchNavController = UINavigationController(rootViewController: searchController)
        
        let plusController = UICollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        plusController.tabBarItem.image = UIImage(named: "plus_unselected")
        plusController.tabBarItem.selectedImage = UIImage(named: "plus_unselected")
        let plusNavController = UINavigationController(rootViewController: plusController)
        
        let likeController = UICollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
            likeController.tabBarItem.image = UIImage(named: "like_unselected")
            likeController.tabBarItem.selectedImage = UIImage(named: "like_selected")
        let likeNavController = UINavigationController(rootViewController: likeController)
        
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
            userProfileController.tabBarItem.image = UIImage(named: "profile_unselected")
            userProfileController.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        let userProfileNavController = UINavigationController(rootViewController: userProfileController)
        
        tabBar.tintColor = UIColor.darkGray
        
        viewControllers = [homeNavController,searchNavController,plusNavController,likeNavController,userProfileNavController]
        
        //Modify images insets
        guard let items = tabBar.items else {return}
        for item in items{
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
}
