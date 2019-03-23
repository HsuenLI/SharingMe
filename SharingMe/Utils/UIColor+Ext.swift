//
//  UIColor+Ext.swift
//  SharingMe
//
//  Created by Hsuen-Ju Li on 2019/1/12.
//  Copyright © 2019 Hsuen-Ju Li. All rights reserved.
//

import UIKit

extension UIColor{
    convenience init(red : Int, green : Int, blue : Int){
        let redValue = CGFloat(red) / 255
        let greenValue = CGFloat(green) / 255
        let blueValue = CGFloat(blue) / 255
        self.init(red: redValue, green: greenValue, blue: blueValue, alpha: 1)
    }
    
    static func mainColor() -> UIColor{
        return UIColor(red: 255, green: 223, blue: 182)
    }
}
