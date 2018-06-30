//
//  BallModel.swift
//  Balls Counter
//
//  Created by Mac on 6/26/18.
//  Copyright © 2018 C0dimus. All rights reserved.
//

import Foundation
import RxDataSources

enum BallType: Int {
    case red, blue
}

struct BallModel {
    let id: Int
    let type: BallType
    var value: Int = 0
    
    init(id: Int, type: BallType) {
        self.id = id
        self.type = type
    }
    
}

extension BallModel: Equatable {
    static func ==(lhs: BallModel, rhs: BallModel) -> Bool {
        return lhs.id == rhs.id && lhs.value == rhs.value
    }
}

extension BallModel: IdentifiableType {
    typealias Identity = Int
    
    var identity: Int {
        return id
    }
}

