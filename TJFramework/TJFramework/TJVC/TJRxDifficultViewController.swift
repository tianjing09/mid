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
    @IBOutlet weak var bt: UIButton!
    
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
       // driver()
       // bindd()
       // fromLatest()
       // uiTest()
        reply()
    }
    
    func uiTest() {
        bt.rx.tap.subscribe(onNext: { _ in
            print("tap按钮被点击")
            Observable.of("dddd")
                .bind(to: self.bt.rx.title(for: .normal))
                .disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
        
        bt.rx.tap.bind{ _ in
            print("bind按钮被点击")
        }
        .disposed(by: disposeBag)
    }
    
    func fromLatest() {
        let pb1 = PublishSubject<Int>()
        let pb2 = PublishSubject<Int>()

        pb1.withLatestFrom(pb2)
            .subscribe { event in
                switch event {
                case .next(let element):
                    print("element:", element)
                case .error(let error):
                    print("error:", error)
                case .completed:
                    print("completed")
                }}
            .disposed(by: disposeBag)

        pb2.onNext(2)
        pb1.onNext(1)//2
        pb1.onNext(11)//2
        pb2.onNext(22)
        pb2.onNext(222)
        pb1.onNext(111)//222
        pb1.onNext(111)//222
        pb2.onNext(3)
        pb2.onNext(33)
        pb1.onNext(111)//33
        pb1.onNext(111)//33
        
        
    }//pb1是依赖于pb2的，当pb2有新值的时候再发送pb1就能得到pb2发送出来的值了，且只能得到pb2
    
    func emptyExample() {
        let observable = Observable<Void>.empty()
        observable.subscribe(onNext: {
           print("empty on next")
        },
        onCompleted: {
           print("empty completed")
        }).disposed(by: disposeBag)
        
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
    func reply() {
        let br: BehaviorRelay<[String]> = BehaviorRelay(value: [])
        br.accept(["ddd"])
        let ob = br.asObservable()
        //let dr = ob.asDriver(onErrorJustReturn: [])
    
        ob.subscribe { (result) in
            print("111:\(result)")
        }.disposed(by: disposeBag)

        
        br.accept(["ccc"])
        br.accept(["eee"])

        
        
//        var r = br.value
//        r.append("ccc")
//        br.accept(r)
//
        let sss = br.asObservable().map { (result) -> Bool in
            print("fffff---\(result)")
            return result.count > 0
        }
        //.asDriver(onErrorJustReturn: false)
        .skip(1)

//        sss.subscribe { (c) in
//            print("333:\(c)")
//        }.disposed(by: disposeBag)
//        sss.drive(nameLabel.rx.isHidden).disposed(by: disposeBag)
//        sss.drive(countLabel.rx.isHidden).disposed(by: disposeBag)
        
        sss.bind(to: nameLabel.rx.isHidden).disposed(by: disposeBag)
        sss.bind(to: countLabel.rx.isHidden).disposed(by: disposeBag)
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            br.accept([])
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            br.accept(["ccc"])
        }
//        br.accept(["fff"])
//        br.accept(["ddd"])

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
//        let b = 33
//        print(String.init(format: "%p", b))
        let myJust = { (element: String) -> Observable<String> in
            return Observable.create { observer -> Disposable in
                a = a + 1
                let ass = "\(element)\(a)"
                observer.on(.next(ass))
                return Disposables.create()
            }
            .share()
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
        }.disposed(by: disposeBag)
        
        j.subscribe {
            print($0)
            //print(String.init(format: "%p", $0))
            withUnsafePointer(to: $0) { pointer in
                print(pointer)
            }
        }.disposed(by: disposeBag)
        
        j.subscribe {
            print($0)
            //print(String.init(format: "%p", $0))
            withUnsafePointer(to: $0) { pointer in
                print(pointer)
            }
        }.disposed(by: disposeBag)
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

//        result.map {event -> String in
//            return "name:\(event)"
//        }.drive(nameLabel.rx.text).disposed(by: disposeBag)
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
            //.asDriver(onErrorJustReturn: "")
            .share(replay: 1)
        
        
        usernameValid.map({ event -> String in
            return "\(event)+1"
        })
            .bind(to:nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        usernameValid
            .bind(to:countLabel.rx.text)
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

