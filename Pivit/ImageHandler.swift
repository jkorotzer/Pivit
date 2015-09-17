//
//  ImageHandler.swift
//  Pivit
//
//  Created by Jared on 9/17/15.
//  Copyright © 2015 Pivit. All rights reserved.
//

import Foundation

class ImageHandler {
    
    func generateClickToAddPhoto() -> UIImage {
        let UInt = UInt32(9)
        let number = Int(arc4random_uniform(UInt))
        let image = UIImage(named: "clickToAddPhoto\(number)")
        return image!
    }
    
}