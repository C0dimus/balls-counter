//
//  BallCollectionViewCell.swift
//  Balls Counter
//
//  Created by Mac on 6/30/18.
//  Copyright © 2018 C0dimus. All rights reserved.
//

import UIKit

class BallCollectionViewCell: UICollectionViewCell {
    static let cellId = "BallCollectionViewCell"
    static let cellSize = CGSize(width: 100, height: 100)
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.backgroundColor = .clear
        borderView.layer.cornerRadius = borderView.bounds.size.width * 0.5
        bgView.layer.cornerRadius = bgView.bounds.size.width * 0.5
    }
    
    func fill(with ballModel: BallModel) {
        switch ballModel.type {
        case .red:
            bgView.backgroundColor = UIColor.lavaRed()
            valueLabel.text = String(ballModel.value)
        case .blue:
            bgView.backgroundColor = UIColor.niceBlue()
            valueLabel.text = String(ballModel.value * 3)
        }
        animateBorderAlpha(ballModel.type)
    }
    
    private func animateBorderAlpha(_ type: BallModelType) {
        let duration = MainViewController.timeInterval * 0.5
        UIView.animate(withDuration: duration, animations: {
            self.borderView.backgroundColor = type == .red ? UIColor.lavaRed(alpha: 0.5) : UIColor.niceBlue(alpha: 0.5)
        }, completion: {_ in
            UIView.animate(withDuration: duration) {
                self.borderView.backgroundColor = .clear
            }
        })
    }

}
