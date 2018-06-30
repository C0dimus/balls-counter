//
//  MainViewController.swift
//  Balls Counter
//
//  Created by Mac on 6/26/18.
//  Copyright © 2018 C0dimus. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopResetButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private var counterViewModel = CounterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterViewModel.balls.asObservable()
            .subscribe(onNext: { balls in
                if let lastBall = balls.last {
                    print("Ball: \(lastBall.type) \(lastBall.value)")
                }
            }).disposed(by: disposeBag)
        
        bindCollectionView()
        bindButtons()
    }
    
    private func bindCollectionView() {
        collectionView.register(UINib(nibName: BallCollectionViewCell.CellId, bundle: Bundle.main), forCellWithReuseIdentifier: BallCollectionViewCell.CellId)
        
        counterViewModel.balls.asObservable().bind(to: collectionView.rx.items) { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BallCollectionViewCell.CellId, for: indexPath) as! BallCollectionViewCell
            cell.fill(ballModel: element)
            return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func bindButtons() {
        counterViewModel.isTimerRunning.asObservable()
            .map { !$0 }
            .bind(to: startButton.rx.isEnabled)
            .disposed(by: disposeBag)
        counterViewModel.isTimerRunning.asObservable()
            .map{ $0 ? "Stop" : "Reset" }
            .bind(to: stopResetButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        startButton.rx.tap
            .debounce(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                print("start pressed")
                self?.startTimer()
            }).disposed(by: disposeBag)
        stopResetButton.rx.tap
            .debounce(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                if self.counterViewModel.isTimerRunning.value {
                    self.counterViewModel.isTimerRunning.value = false
                } else {
                    self.counterViewModel.resetBalls()
                }
            }).disposed(by: disposeBag)
    }
    
    private func startTimer() {
        self.counterViewModel.isTimerRunning.value = true
        Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
            .takeWhile({ [unowned self] i -> Bool in
                self.counterViewModel.isTimerRunning.value
            })
            .subscribe(onNext: {[unowned self] i in
                self.counterViewModel.generateRandom()
            }).disposed(by: disposeBag)
    }

}
