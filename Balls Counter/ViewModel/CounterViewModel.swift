//
//  CounterViewModel.swift
//  Balls Counter
//
//  Created by Mac on 6/26/18.
//  Copyright © 2018 C0dimus. All rights reserved.
//

import Foundation
import RxSwift

enum RandomAction {
    case increaseBallValue
    case resetBallValue
    case deleteBall
    case addPreviousBallValue
    case unrecognized
    
    init(_ randomNumber: Int) {
        switch randomNumber {
        case 0 ..< 50:
            self = .increaseBallValue
        case 50 ..< 85:
            self = .resetBallValue
        case 85 ..< 95:
            self = .deleteBall
        case 95 ..< 100:
            self = .addPreviousBallValue
        default:
            self = .unrecognized
        }
    }
}

struct CounterViewModel {
    private static let RequiredBallsNumber = 5
    var balls = Variable<[BallModel]>([])
    var isTimerRunning = Variable<Bool>(false)
    private var previousBallValue = 0
    
    mutating func generateRandom() {
        if balls.value.count < CounterViewModel.RequiredBallsNumber {
            generateRandomBall()
        } else {
            generateRandomAction()
        }
    }
    
    private func generateRandomBall() {
        let randomNumber = Int(arc4random_uniform(2))
        if let ballType = BallType(rawValue: randomNumber) {
            let randomBall = BallModel(type: ballType)
            balls.value.append(randomBall)
        }
    }
    
    private mutating func generateRandomAction() {
        let randomBallNumber = Int(arc4random()) % balls.value.count
        let randomBall = balls.value[randomBallNumber]
        let randomActionNumber = Int(arc4random_uniform(100))
        let action = RandomAction(randomActionNumber)
        switch action {
        case .increaseBallValue:
            print("RANDOM: increase")
            randomBall.value += 1
        case .resetBallValue:
            print("RANDOM: reset")
            randomBall.value = 0
        case .deleteBall:
            print("RANDOM: delete")
            balls.value.remove(at: randomBallNumber)
        case .addPreviousBallValue:
            print("RANDOM: previous")
            randomBall.value += previousBallValue
        default:
            return
        }
        previousBallValue = randomBall.value
    }
    
}
