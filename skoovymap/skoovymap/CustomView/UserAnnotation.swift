//
//  UserAnnotation.swift
//  skoovymap
//
//  Created by Rock on 5/6/17.
//  Copyright © 2017 Rock. All rights reserved.
//

import Foundation
import MapKit
import UIKit
class UserAnnotation: MKPointAnnotation {
    var avatar_index:Int = 0 {
        didSet{
            if(is_user == true){
                if(avatar_index != 0){
                    let path = ConstantVars().user_avatar_array[avatar_index - 1]
                    imageView = UIImage(named:path)
                }
            }
            else{
                let path = ConstantVars().location_avatar_array[avatar_index]
                imageView = UIImage(named: path)
            }
        }
    }
    var is_user:Bool = true // true: user avatar false: location avatar
    var imageView:UIImage!
    var uid:String!
    var count_posts:Int = 1
}
