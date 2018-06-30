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
    
    private let disposeBag = DisposeBag()
    private var counterViewModel = CounterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindButtons()
//        counterViewModel.balls.asObservable()
//            .subscribe(onNext: { ball in
//                print("ball \(ball)")
//        }).disposed(by: disposeBag)
        
//        counterViewModel.balls.asObservable().bind(to: collectionView.rx.items) { (collectionView, row, element) in
////            let indexPath = IndexPath(row: row, section: 0)
////            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! NumberCell
////            cell.value?.text = "\(element) @ \(row)"
////            return cell
//            }
//            .disposed(by: disposeBag)
        
      
    }
    
    private func bindButtons() {
        counterViewModel.isTimerRunning.asObservable()
            .map { !$0 }
            .bind(to: startButton.rx.isEnabled)
            .disposed(by: disposeBag)
        startButton.rx.tap
            .debounce(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                print("start pressed")
                self?.startTimer()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
