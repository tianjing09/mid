//
//  TJRxDifficultViewController.swift
//  TJFramework
//
//  Created by jing 田 on 2020/12/21.
//  Copyright © 2020 jing 田. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TJRxDifficultViewController: TJBaseViewController {

    @IBOutlet weak var tf: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //emptyExample()
        //nextDiff()
        //never()
        //noDefer()
        //doDefer()
        //publish()
        //mapAndFlat()
        driver()
        //bindd()
    }
    
    func emptyExample() {
        let observable = Observable<Void>.empty()
        observable.subscribe(onNext: {
           print("empty on next")
        },
        onCompleted: {
           print("empty completed")
        })
    }
    func nextDiff() {
        let observable = Observable.of("a","b","c")
        observable.subscribe { event in
            print(event)
        }.disposed(by: DisposeBag())
        
        observable.subscribe(onNext: { event in
            print("next:\(event)")
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("completed")
        }, onDisposed: {
            print("dispose")
        }).dispose()
    }
    
    func never() {
        let obs = Observable<Void>.never()
        obs.subscribe(onNext: {
            print("next never")
        },  onCompleted: {
            print("completed never")
        }, onDisposed: {
            print("dispose never")
        }).dispose()
    }
    
    func noDefer() {
        let bag = DisposeBag()
        var value: String? = nil
        var a = 1
        var obs: Observable<String?> = Observable.just("\(String(describing: value))+\(a+=1)")
        value = "hello"
        obs.subscribe { event in
            print(event)
        }.disposed(by: bag)
        
        obs.subscribe { event in
            print(event)
        }.disposed(by: bag)
    }
    
    func doDefer() {
        var value: String? = "ddd"
        var a = 1
        var obs: Observable<String?> = Observable.deferred {
            a = a + 1
            return  Observable.just("\(value ?? "yyy")+\(a)")
        }
        value = "defer hello"
        
        obs.subscribe { event in
            print(event)
        }
        obs.subscribe { event in
            print(event)
        }
        obs.subscribe { event in
            print(event)
        }
        
        
    }
    func address(o: UnsafeRawPointer) -> Int {
        return Int(bitPattern: o)
    }

    func addressHeap<T: AnyObject>(o: T) -> Int {
        return unsafeBitCast(o, to: Int.self)
    }
    
    func publish() {
        var a = 3
        let b = 33
        print(String.init(format: "%p", b))
        let myJust = { (element: String) -> Observable<String> in
            return Observable.create { observer -> Disposable in
                a = a + 1
                var ass = "\(element)\(a)"
                observer.on(.next(ass))
                return Disposables.create()
            }.share()
        }
        let j = myJust("j")
        j.subscribe { event in
            print(event)
            //print(NSString(format: "%p", address(o: &event)))
            //print("\(Unmanaged.passRetained(event as AnyObject))")
//            var e = event
//            withUnsafePointer(to: &e) { pointer in
//                print(pointer)
//            }
            withUnsafePointer(to: event) { pointer in
                print(pointer)
            }
        }.disposed(by: DisposeBag())
        
        j.subscribe {
            print($0)
            //print(String.init(format: "%p", $0))
            withUnsafePointer(to: $0) { pointer in
                print(pointer)
            }
        }.disposed(by: DisposeBag())
        
        j.subscribe {
            print($0)
            //print(String.init(format: "%p", $0))
            withUnsafePointer(to: $0) { pointer in
                print(pointer)
            }
        }.disposed(by: DisposeBag())
    }
    
    func share() {
        
    }

    func driver() {
        /*
         Behavior,ControlEvent,ControlProperty三个类有Driver的扩展，即转化为Driver的方法，所以Driver一般都是和控件UI绑定。
         Driver的本质是序列SharedSequence
         Trait that represents observable sequence with following properties:

         - it never fails
         - it delivers events on `MainScheduler.instance`
         - `share(replay: 1, scope: .whileConnected)` sharing strategy
         1、Driver 可以说是最复杂的 trait，它的目标是提供一种简便的方式在 UI 层编写响应式代码。
         2、如果我们的序列列满⾜足如下特征，就可以使⽤用它:
         • 不会产⽣生 error 事件，当有error的时候，可以返回自己业务逻辑的相关错误提示
         • 一定在主线程监听(MainScheduler)
         • 共享状态变化(shareReplayLatestWhileConnected)
         使⽤构建 Driver 的可观察的序列，它是共享状态变化，可以多次订阅，只用走一次网络请求。
         Observablea.sDriver
         .drive(label.rx.text)绑定ui
         */
//        let result = self.tf.rx.text.orEmpty.throttle(0.3, scheduler: MainScheduler.instance).flatMapLatest { text in
//            self.dealWithData(query: text)
//        }
//        let result = self.tf.rx.text.orEmpty.throttle(0.3, scheduler: MainScheduler.instance).flatMapLatest { text in
//            self.dealWithData(query: text).observeOn(MainScheduler.instance)
//                .catchErrorJustReturn("").share(replay: 1)
//        }
        let result = self.tf.rx.text.orEmpty.throttle(0.3, scheduler: MainScheduler.instance).flatMapLatest { text in
            self.dealWithData(query: text).asDriver(onErrorJustReturn:"")
        }.asDriver(onErrorJustReturn: "")
        
//        let result = tf.rx.text.orEmpty.map { event -> String in
//            print("ttt")
//            return "\(event)+1"
//        }.asDriver(onErrorJustReturn: "")
        
        result.map { event -> String in
           return "count:\(event.count)"
        }.drive(self.countLabel.rx.text).disposed(by: disposeBag)
        
        result.map {event -> String in
            return "name:\(event)"
        }.drive(nameLabel.rx.text).disposed(by: disposeBag)
    }
    
    func dealWithData(query:String) -> Observable<String> {
        print("begin request\(Thread.current)")
        return Observable<String>.create { (obs) -> Disposable in
            if query == "1234" {
                obs.onError(NSError.init(domain: "com.tj.cn", code: 400, userInfo: nil))
            }
            DispatchQueue.global().async {
                print("begin:\(Thread.current)")
                obs.onNext("ddd\(query)")
                obs.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func bindd() {
        let usernameValid = tf.rx.text.orEmpty
            .map { event -> String in
                print("vvv")
                return  "\(event)+1"
            }
            .asDriver(onErrorJustReturn: "")
            //.share(replay: 1)
        
        
        usernameValid.map({ event -> String in
            return "\(event)+1"
        })
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        usernameValid
            .drive(countLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func mapAndFlat() {
//        let obs = Observable.of("1","2","3").map {
//            $0 + "tianjing"
//        }
//        obs.subscribe { event in
//            print(event)
//        }.disposed(by: DisposeBag())
        
//        let obs = Observable.of("1","2","3").map {
//            Observable.just($0)
//        }
//        let obs = Observable.of("1","2","3").map {
//            Observable.just($0)
//        }.merge()
//        obs.subscribe(onNext:{
//            print($0)
//        })
        
        let obs = Observable.of("1","2","3").flatMap {
            Observable.just($0)
        }
//        obs.subscribe { event in
//            print(event)
//        }.disposed(by: DisposeBag())
        obs.map {
            $0
        }.subscribe {
           print($0)
        }
    }
}
