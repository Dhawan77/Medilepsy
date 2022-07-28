//
//  TutorialModel.swift
//  Medilepsy
//
//  Created by John on 05/02/21.
//

import Foundation
import UIKit

struct TutorialModel {
    var msg:String?
    var img: UIImage?
  
    
    init(msg:String,img:UIImage){
        self.msg = msg
        self.img = img
    }
}
