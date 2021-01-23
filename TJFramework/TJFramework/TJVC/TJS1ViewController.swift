//
//  TJS1ViewController.swift
//  TJFramework
//
//  Created by jing 田 on 2021/1/23.
//  Copyright © 2021 jing 田. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TJS1ViewController: TJBaseViewController {
    let totalSignal: BehaviorRelay<Int> = BehaviorRelay.init(value: 0)
    let countsSignal: BehaviorRelay<[String]> = BehaviorRelay.init(value: [])
    let isCompletedSignal: BehaviorRelay<Bool> = BehaviorRelay.init(value: false)
    
    lazy var dataSourceSignal: Driver<[String]> = {
        let signal =  Observable.combineLatest(totalSignal, countsSignal) { (total, counts) -> [String] in
            if total > 0 {
                let added = counts.map { (string) -> String in
                    return "tjdd:\(string)"
                }
                return added
            } else {
                return []
            }
        }
        .asDriver(onErrorJustReturn: []).distinctUntilChanged()
        return signal
    }()
    
    lazy var noDataSignal: Driver<Int> = {
        let signal = Observable.combineLatest(totalSignal, countsSignal, isCompletedSignal){ (total, counts, isCompleted) -> Int in
            if isCompleted, counts.count == 0 {
                return total
            } else {
                return 0
            }
        }.asDriver(onErrorJustReturn: 0).distinctUntilChanged()
        return signal
    }()
    
    lazy var isHidden: Driver<Bool> = {
        let isHidden = dataSourceSignal.map({ (counts) -> Bool in
            return counts.count == 0
        }).distinctUntilChanged()
        return isHidden
    }()
    
    let group = DispatchGroup()
    let queue = DispatchQueue.global()
    
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSignal()
        ggroup()
        
//        request()
//        request1()
    }
    
    func ggroup() {
        let types = [Type.a, Type.b, Type.c]
        var time = DispatchTime.now()
        for type in types {
            let item = DispatchWorkItem.init {
                time = time + 4
               // print("time:\(time)")
                self.queue.asyncAfter(deadline: time) {
                    NSLog("\(type)")
                    var counts = self.countsSignal.value
                    counts.append("tian")
                    self.countsSignal.accept(counts)
                    self.group.leave()
                }
            }
            group.enter()
            //queue.async(group: group, execute: item)
            queue.async(execute: item)
        }
        
        let item1 = DispatchWorkItem.init {
            self.queue.asyncAfter(deadline: .now() + 3) {
                NSLog("total")
                self.totalSignal.accept(10)
                self.group.leave()
            }
        }
        group.enter()
        //queue.async(group: group, execute: item1)
        queue.async(execute: item1)
        
        group.notify(queue: DispatchQueue.main) {
            NSLog("iscompleted")
        }
    }
    
    func request() {
        isCompletedSignal.accept(false)
        countsSignal.accept(["a"])
        countsSignal.accept(["a", "b"])
        totalSignal.accept(10)
        countsSignal.accept(["a", "b", "c"])
        isCompletedSignal.accept(true)
    }
    
    func request1() {
        print("++++++++++++++++++")
        isCompletedSignal.accept(false)
        countsSignal.accept([])
        countsSignal.accept([])
        totalSignal.accept(10)
        countsSignal.accept([])
        isCompletedSignal.accept(true)
    }
    
    func initialData() {
        isCompletedSignal.accept(false)
        totalSignal.accept(0)
    }
    
    func setSignal() {

        dataSourceSignal.drive{ (counts) in
            print("data:\(counts)")
        }.disposed(by: disposeBag)
        
        noDataSignal.drive{ (total) in
            print("total:\(total)")
        }.disposed(by: disposeBag)
                
        isHidden.drive{ (isHidden) in
            print("hide:\(isHidden)")
        }.disposed(by: disposeBag)
        
    }
}

enum Type {
    case a
    case b
    case c
    case d
}
