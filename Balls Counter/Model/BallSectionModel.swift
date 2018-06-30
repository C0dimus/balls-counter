//
//  BallSectionModel.swift
//  Balls Counter
//
//  Created by Mac on 6/30/18.
//  Copyright © 2018 C0dimus. All rights reserved.
//

import RxDataSources

struct BallSectionModel: AnimatableSectionModelType {
    typealias Item = BallModel
    typealias Identity = String
    var header: String
    var items: [Item]
    
    
    init(original: BallSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
    
    init(header: String, items: [Item]) {
        self.header = header
        self.items = items
    }
    
    var identity: String {
        return header
    }
    
}

