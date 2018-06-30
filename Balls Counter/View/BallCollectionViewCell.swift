//
//  BallCollectionViewCell.swift
//  Balls Counter
//
//  Created by Mac on 6/30/18.
//  Copyright © 2018 C0dimus. All rights reserved.
//

import UIKit

class BallCollectionViewCell: UICollectionViewCell {
    static let CellId = "BallCollectionViewCell"
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = bgView.bounds.size.width * 0.25
    
    }
    
    func fill(ballModel: BallModel) {
        switch ballModel.type {
        case .red:
            bgView.backgroundColor = UIColor.lavaRed
            valueLabel.text = String(ballModel.value)
        case .blue:
            bgView.backgroundColor = UIColor.niceBlue
            valueLabel.text = String(ballModel.value * 3)
        }
    }

}
