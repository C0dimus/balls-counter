//
//  BallCollectionViewLayout.swift
//  Balls Counter
//
//  Created by Mac on 7/1/18.
//  Copyright © 2018 C0dimus. All rights reserved.
//

import UIKit

class BallCollectionViewLayout: UICollectionViewFlowLayout {
    private var decorationsFrames = [CGRect]()
    
    override init() {
        super.init()
        self.itemSize = BallCollectionViewCell.cellSize
        self.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15)
        self.register(UINib(nibName: BallCollectionDecorationView.nibName, bundle: Bundle.main), forDecorationViewOfKind: BallCollectionDecorationView.nibName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = super.layoutAttributesForElements(in: rect)
        for i in 0 ..< CounterViewModel.requiredBallsNumber {
            if let decorationAttributes = self.layoutAttributesForDecorationView(ofKind: BallCollectionDecorationView.nibName, at: IndexPath(item: i, section: 0)) {
                if rect.contains(decorationAttributes.frame) {
                    layoutAttributes?.append(decorationAttributes)
                }
            }
        }
        
        return layoutAttributes
    }
    
    override func layoutAttributesForDecorationView(
        ofKind elementKind: String, at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
            if elementKind == BallCollectionDecorationView.nibName {
                let atts = UICollectionViewLayoutAttributes(
                    forDecorationViewOfKind:BallCollectionDecorationView.nibName, with:indexPath)
                atts.frame = decorationsFrames[indexPath.item]
                atts.zIndex = -1
                return atts
            }
            return nil
    }
    
    override func prepare() {
        super.prepare()
        if self.decorationsFrames.isEmpty {
            self.decorationsFrames = calculatedDecorationsFrames()
        }
    }
    
    private func calculatedDecorationsFrames() -> [CGRect] {
        guard let collectionSize = collectionView?.frame.size else {
            return []
        }
        
        var frames = [CGRect]()
        let ballWidth = BallCollectionViewCell.cellSize.width
        let ballHeight = BallCollectionViewCell.cellSize.height
        let numberOfBallsInRow = floor((collectionSize.width - sectionInset.left - sectionInset.right) / ballWidth)
        let numberOrLines = Int(ceil(CGFloat(CounterViewModel.requiredBallsNumber) / numberOfBallsInRow))
        let horizontalSpaceBettwenBalls = (collectionSize.width - numberOfBallsInRow * ballWidth - sectionInset.left - sectionInset.right) / (numberOfBallsInRow - 1)
        for line in 0 ..< numberOrLines {
            for row in 1 ... Int(numberOfBallsInRow) {
            let frame = CGRect(x: (ballWidth + sectionInset.left + horizontalSpaceBettwenBalls / 2) * CGFloat(row),
                               y: ballHeight * CGFloat(line) + sectionInset.top * (CGFloat(line) + 1),
                               width: BallCollectionDecorationView.width,
                               height: line < numberOrLines - 1 ? ballHeight * 2 : ballHeight)
            frames.append(frame)
            }
        }
        return frames
    }
    
}
