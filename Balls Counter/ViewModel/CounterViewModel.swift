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
    static let requiredBallsNumber = 5
    var balls = Variable<[BallModel]>([])
    var isTimerRunning = Variable<Bool>(false)
    private var previousBallValue = 0
    private var ballIdentifier = 0
    
    mutating func generateRandom() {
        if balls.value.count < CounterViewModel.requiredBallsNumber {
            generateRandomBall()
        } else {
            generateRandomAction()
        }
    }
    
    mutating func resetBalls() {
        balls.value = []
        ballIdentifier = 0
    }
    
    private mutating func generateRandomBall() {
        let randomNumber = Int(arc4random_uniform(2))
        if let ballType = BallModelType(rawValue: randomNumber) {
            let randomBall = BallModel(id: ballIdentifier, type: ballType)
            balls.value.append(randomBall)
            ballIdentifier += 1
        }
    }
    
    private mutating func generateRandomAction() {
        let randomBallNumber = Int(arc4random()) % balls.value.count
        var randomBall = balls.value[randomBallNumber]
        let randomActionNumber = Int(arc4random_uniform(100))
        let action = RandomAction(randomActionNumber)
        print("\(randomBallNumber + 1) \(action)")
        switch action {
        case .increaseBallValue:
            randomBall.value += 1
        case .resetBallValue:
            randomBall.value = 0
        case .deleteBall:
            balls.value.remove(at: randomBallNumber)
            return
        case .addPreviousBallValue:
            randomBall.value += previousBallValue
        default:
            return
        }
        balls.value[randomBallNumber] = randomBall
        previousBallValue = randomBall.value
    }

}
