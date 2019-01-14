//
//  UINavigationController+Ext.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/14.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

//Hidden status bar in iPhone x and above
extension UINavigationController {
    override open var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
}
