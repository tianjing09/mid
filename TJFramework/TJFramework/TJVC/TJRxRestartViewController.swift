//
//  TJRxRestartViewController.swift
//  TJFramework
//
//  Created by jing 田 on 2020/12/26.
//  Copyright © 2020 jing 田. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DynamicSDK
import DynamicSDK1
import Doctor

struct  Player {
    var score: Variable<Int>
}

class TJRxRestartViewController: TJBaseViewController, UIScrollViewDelegate {
    let disposeBag = DisposeBag()
    
    lazy var scrollView: UIScrollView = {
       let sc = UIScrollView(frame: CGRect(x: 20, y: 400, width: 200, height: 300))
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let p = PrintTest(description: "dddd")
        p.printName("tianjing")
        p.printDescription()
        
        let circle = CircleView(frame: CGRect(x: 20, y: 44, width: 300, height: 300))
        circle.backgroundColor = .green
        self.view.addSubview(circle)
        circle.refreshView(with: ["40","80","160"], colors: [.purple,.yellow,.blue])
        
        //rxStartWith()
        //rxMerge()
        //rxZip()
        //rxCombineLatest()
        //rxMap()
       // rxFlatMap()
       // rxFlatMapLatest()
        rxFlatMap1()
        let button = UIButton.init(type: .contactAdd)
        button.frame = CGRect(x: 40, y: 400, width: 100, height: 100)
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(presentt), for: .touchUpInside)
        addSc()
        var hasher = Hasher()
        hasher.combine(23)
        hasher.combine("hello")
        let hashValue = hasher.finalize()
        print(hashValue)
    }
    
    func addSc() {
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: 200, height: 1000)
        scrollView.backgroundColor = .green
        scrollView.delegate = self
    }
    
    func table() {
      
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }
    
    @objc func presentt() {
        let vc = DoctorViewController()
        self.present(vc, animated: true, completion: nil)
    }

    func rxStartWith() {
        Observable.of("1","2")
            .startWith("4")
            .subscribe(onNext:{ print($0)})
            .disposed(by:disposeBag)
    }
    
    func rxMerge() {
        let sub1 = PublishSubject<String>()
        let sub2 = PublishSubject<String>()
        Observable.of(sub1,sub2)
            .merge()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        sub1.onNext("1")
        sub1.onNext("2")
        sub1.onNext("3")
        sub2.onNext("a")
        sub2.onNext("b")
        sub2.onNext("c")
    }
    
    func rxZip() {
        let sub1 = PublishSubject<String>()
        let sub2 = PublishSubject<Int>()
        Observable.zip(sub1,sub2) { s1,i2 in
            "\(s1)--\(i2)"
        }
        .subscribe(onNext: {print($0)} )
        .disposed(by: disposeBag)
        
        sub1.onNext("a")
        sub1.onNext("b")
        sub2.onNext(8)
        sub1.onNext("c")
        sub2.onNext(1)
        sub2.onNext(2)
        sub2.onNext(3)
    }
    
    func rxCombineLatest() {
        let sub1 = PublishSubject<String>()
        let sub2 = PublishSubject<Int>()
        Observable.combineLatest(sub1,sub2) { s1,i2 in
            "\(s1)--\(i2)"
        }
        .subscribe(onNext: {print($0)} )
        .disposed(by: disposeBag)
        
        sub1.onNext("a")
        sub1.onNext("b")
        sub2.onNext(8)
        sub1.onNext("c")
        sub2.onNext(1)
        sub2.onNext(2)
        sub2.onNext(3)
    }
    
    func rxMap() {
        let p1 = Player(score: Variable(1))
        let p2 = Player(score: Variable(2))
        let player = Variable(p1)
        player.asObservable()
            .map {_ in
                Variable(p2)
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        p1.score.value = 11
        player.value = p2
        p2.score.value = 22
        p1.score.value = 111
        p2.score.value = 2222
        p1.score.value = 10
        p2.score.value = 20
    }
    
    
    func rxFlatMap() {
        let p1 = Player(score: Variable(1))
        let p2 = Player(score: Variable(2))
        let player = Variable(p1)
        player.asObservable()
            .flatMap {
                $0.score.asObservable()
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        p1.score.value = 11
        player.value = p2
        p2.score.value = 22
        p1.score.value = 111
        p2.score.value = 2222
        p1.score.value = 10
        p2.score.value = 20
    }
    
    func rxFlatMap1()  {
        Observable.of([1,2,3],[4,5,6],[7,8,9]).flatMapLatest {
            Observable.just($0)
        }.subscribe(onNext: {print($0)})
        .disposed(by: disposeBag)
    }
    
    func rxFlatMapLatest() {
        let p1 = Player(score: Variable(1))
        let p2 = Player(score: Variable(2))
        let player = Variable(p1)
        player.asObservable()
            .flatMapLatest {
                $0.score.asObservable()
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        p1.score.value = 11
        player.value = p2
        p2.score.value = 22
        p1.score.value = 111
        p2.score.value = 2222
        player.value = p1
        p1.score.value = 10
        p2.score.value = 20
    }
    
}
