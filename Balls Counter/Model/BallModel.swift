//
//  BallModel.swift
//  Balls Counter
//
//  Created by Mac on 6/26/18.
//  Copyright © 2018 C0dimus. All rights reserved.
//

import Foundation

enum BallType: Int {
    case red, blue
}

class BallModel {
    let type: BallType
    var value: Int = 0
    
    init(type: BallType) {
        self.type = type
    }
    
}
