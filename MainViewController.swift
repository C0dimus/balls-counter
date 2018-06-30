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
import RxDataSources

class MainViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopResetButton: UIButton!
    
    private static let timeInterval = 1.0
    private let disposeBag = DisposeBag()
    private var counterViewModel = CounterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        bindButtons()
    }
    
    private func prepareCollectionView() {
        collectionView.register(UINib(nibName: BallCollectionViewCell.CellId, bundle: Bundle.main), forCellWithReuseIdentifier: BallCollectionViewCell.CellId)

        let dataSource = RxCollectionViewSectionedAnimatedDataSource<BallSectionModel>(configureCell:  { (_, collectionView, indexPath, ballModel) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BallCollectionViewCell.CellId, for: indexPath) as! BallCollectionViewCell
            cell.fill(with: ballModel)
            return cell
        }, configureSupplementaryView: {_, _, _, _ in return UICollectionReusableView() })
        
        counterViewModel.balls.asDriver()
            .map{ [BallSectionModel(header: "", items: $0)] }
            .drive(collectionView.rx.items(dataSource: dataSource))
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
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.startTimer()
            }).disposed(by: disposeBag)
        stopResetButton.rx.tap
            .throttle(0.5, scheduler: MainScheduler.instance)
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
        Observable<Int>.interval(MainViewController.timeInterval, scheduler: MainScheduler.instance)
            .takeWhile({ [unowned self] _ -> Bool in
                self.counterViewModel.isTimerRunning.value
            })
            .subscribe(onNext: { [unowned self] _ in
                self.counterViewModel.generateRandom()
            }).disposed(by: disposeBag)
    }

}
