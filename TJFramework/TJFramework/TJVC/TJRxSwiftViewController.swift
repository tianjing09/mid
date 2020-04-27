//
//  TJRxSwiftViewController.swift
//  TJFramework
//
//  Created by jing 田 on 2019/9/19.
//  Copyright © 2019年 jing 田. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
//歌曲结构体
struct Music {
    let name: String //歌名
    let singer: String //演唱者
    
    init(name: String, singer: String) {
        self.name = name
        self.singer = singer
    }
}

//实现 CustomStringConvertible 协议，方便输出调试
extension Music: CustomStringConvertible {
    var description: String {
        return "name：\(name) singer：\(singer)"
    }
}
//歌曲列表数据源

//歌曲列表数据源
struct MusicListViewModel {
    let data = Observable.just([
        Music(name: "无条件", singer: "陈奕迅"),
        Music(name: "你曾是少年", singer: "S.H.E"),
        Music(name: "从前的我", singer: "陈洁仪"),
        Music(name: "在木星", singer: "朴树"),
        ])
}

class TJRxSwiftViewController: TJBaseViewController {
    lazy var tableView: UITableView = {
        let table = UITableView.init(frame: CGRect(x: 60, y: 80, width: 200, height: 300), style: .plain)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "musicCell")
        table.backgroundColor = .yellow
        return table
    }()
    lazy var label: UILabel = {
        let lab = UILabel.init(frame: CGRect(x: 20, y: 400, width: 300, height: 30))
        lab.backgroundColor = .purple
        return lab
    }()
    
    lazy var viewHeight: CGFloat = {
        return self.view.bounds.size.height
    }()
    
    lazy var viewWidth: CGFloat = {
        return self.view.bounds.size.width
    }()
    //负责对象销毁
    let disposeBag = DisposeBag()
    let musicListViewModel = MusicListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        self.view.addSubview(label)
        //将数据源数据绑定到tableView上
        musicListViewModel.data
            .bind(to: tableView.rx.items(cellIdentifier:"musicCell")) { _, music, cell in
                cell.textLabel?.text = music.name
                cell.detailTextLabel?.text = music.singer
            }.disposed(by: disposeBag)
        
        //tableView点击响应
        tableView.rx.modelSelected(Music.self).subscribe(onNext: { music in
            print("你选中的歌曲信息【\(music)】")
        }).disposed(by: disposeBag)
        // Do any additional setup after loading the view.
        observableTest()
        observalBind()
        publishSub()
        behaviorSub()
        replaySub()
        variablesSub()
       // buffer()
        //window()
        map()
        flatMap()
        flatMapLatest()
        concatMap()
        scan()
        groupBy()
        filter()
        distinctUntilChanged()
        single()
        elementAt()
        ignoreElement()
        take()
        takeLast()
        skip()
        sample()
        debounce()
        amb()
        takeWhile()
        takeUnitl()
        skipWhile()
        skipUntil()
        startWith()
        merge()
        zip()
        combineLatest()
        withLatestFrom()
        switchLatest()
        toArray()
        reduce()
        concat()
    }
    
    func observableTest() {
       let observableG = Observable.generate(initialState: 0, condition: { $0 <= 10 }, iterate: { $0 + 2 })
        
       let subscribtion = observableG.subscribe{
          print("gg\($0)")
        }
        
        subscribtion.dispose()
        observableG
            .do(onNext: { element in
                print("Intercepted Next：", element)
            }, onError: { error in
                print("Intercepted Error：", error)
            }, onCompleted: {
                print("Intercepted Completed")
            }, onDispose: {
                print("Intercepted Disposed")
            })
            .subscribe(onNext: { element in
                print(element)
            }, onError: { error in
                print(error)
            }, onCompleted: {
                print("completed")
            }, onDisposed: {
                print("disposed")
            })
        
        let observableC = Observable<String>.create{observer in
            observer.onNext("tianjing")
            observer.onCompleted()
            return Disposables.create()
        }
        observableC.subscribe{
          print("cc\($0)")
        }
    }
    
    func observalBind() {
        /*//one
        let observer1: AnyObserver<Int> = AnyObserver { (event) in
            switch event {
            case .next(let data):
                print("rrr:\(data)")
            case .error(let error):
                print("rrr:\(error)")
            case .completed:
                print("rrr:completed")
            }
        }
        
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable.map { (signal) -> String in
            return "current index:\(signal)"
            }.bind { [weak self](mapString)in
               self?.label.text = mapString
            }.disposed(by: disposeBag)
        
        observable.subscribe(observer1)//observer1 int
       */
        
//        let observer: Binder<String> = Binder(label) {(view, text) in
//           view.text = text
//        }
//
//        let observale = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//        observale.map { (signal) -> String in
//            return "current index:\(signal)"
//        }.bind(to: observer).disposed(by: disposeBag)
        label.text = "tian"
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//        observable.map { (size) -> CGFloat in
//            CGFloat(size)
//        }.bind(to: label.fontSize).disposed(by: disposeBag)
        
//        observable.map{CGFloat($0)}.bind(to: label.rx.fontSize).disposed(by: disposeBag)
        
        observable.map{"current index:\($0)"}.bind(to: label.rx.text).disposed(by: disposeBag)
    }
    
    func publishSub() {//Complete,error结束之后就不在订阅其他，只会接收到completed消息
        let subject = PublishSubject<String>()
        subject.onNext("111")
        subject.subscribe (onNext: {text in
            print("first:",text)
        },onCompleted:{
            print("first:completed")
        }).disposed(by: disposeBag)
            
        //当前有1个订阅，则该信息会输出到控制台
        subject.onNext("222")
        
        //第2次订阅subject
        subject.subscribe(onNext: { string in
            print("第2次订阅：", string)
        }, onCompleted:{
            print("第2次订阅：onCompleted")
        }).disposed(by: disposeBag)
        
        //当前有2个订阅，则该信息会输出到控制台
        subject.onNext("333")
        
        //让subject结束
        subject.onCompleted()
        
        //subject完成后会发出.next事件了。
        subject.onNext("444")
        
        //subject完成后它的所有订阅（包括结束后的订阅），都能收到subject的.completed事件，
        subject.subscribe(onNext: { string in
            print("第3次订阅：", string)
        }, onCompleted:{
            print("第3次订阅：onCompleted")
        }).disposed(by: disposeBag)
    }
    
    func behaviorSub(){//需要通过一个默认初始值来创建,当一个订阅者来订阅它的时候，这个订阅者会立即收到 BehaviorSubjects 上一个发出的event
       let subject = BehaviorSubject(value: "b111")
        subject.subscribe { event in
            print("first:",event)
        }.disposed(by: disposeBag)
        
        subject.onNext("b222")
        subject.onError(NSError(domain: "local", code: 0, userInfo: nil))
        
        subject.subscribe { event in
            print("second:",event)
        }.disposed(by: disposeBag)
    }
    
    func replaySub(){//起始订阅，缓存显示
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        
        subject.onNext("r111")
        subject.onNext("r222")
        subject.onNext("r333")
        
        subject.subscribe { (event) in
            print("first",event)
        }.disposed(by: disposeBag)//起始订阅，缓存显示，以后正常
        
        subject.onNext("r444")
        
        subject.subscribe { event in
            print("second：", event)
        }.disposed(by: disposeBag)
        
        //让subject结束
        subject.onCompleted()
        
        //第3次订阅subject
        subject.subscribe { event in
            print("third：", event)
        }.disposed(by: disposeBag)
    }
    
    func variablesSub() {// Variable 有一个 value 属性，我们改变这个 value 属性的值就相当于调用一般  Subjects 的 onNext() 方法，而这个最新的 onNext() 的值就被保存在 value 属性里了，直到我们再次修改它。
        let variable = Variable("v111")
        variable.value = "v222"
        
        variable.asObservable().subscribe {
            print("first:\($0)")
        }.disposed(by: disposeBag)
        
        variable.value = "v333"
        
        variable.asObservable().subscribe {
            print("second:\($0)")
        }.disposed(by: disposeBag)
        
         variable.value = "v444"
    }
    
    func buffer(){
       let subject = PublishSubject<String>()
       subject.buffer(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
        .subscribe(onNext:{print($0)}).disposed(by:disposeBag)
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
    }
    
    func window(){
        let subject = PublishSubject<String>()
        subject.window(timeSpan: 1, count: 3, scheduler: MainScheduler.instance).subscribe(onNext:{[weak self] in
            print("subscribe:\($0)")
            $0.asObservable().subscribe(onNext:{print($0)}).disposed(by:self!.disposeBag)
        }).disposed(by: disposeBag)
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
    }
    
    func map(){
        Observable.of(1,2,3)
            .map {$0 * 10}
            .subscribe(onNext: {print($0)}).disposed(by: disposeBag)
    }
    
    func flatMap(){
        let subject1 = BehaviorSubject(value: "a")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject1)
        
        variable.asObservable().flatMap{
            $0
            }.subscribe(onNext:{print($0)}).disposed(by: disposeBag)
        
        subject1.onNext("b")
        variable.value = subject2
        subject2.onNext("2")
        subject1.onNext("c")
    }
    
    func flatMapLatest() {
        print("latest-------")
        let subject1 = BehaviorSubject(value: "a")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject1)
        
        variable.asObservable().flatMapLatest{
            $0
            }.subscribe(onNext:{print($0)}).disposed(by: disposeBag)
        
        subject1.onNext("b")
        variable.value = subject2
        subject2.onNext("2")
        subject1.onNext("c")
    }
    
    func concatMap(){
        print("concat-------")
        let subject1 = BehaviorSubject(value: "a")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject1)
        
        variable.asObservable().concatMap{
            $0
            }.subscribe(onNext:{print($0)}).disposed(by: disposeBag)
        
        subject1.onNext("b")
        variable.value = subject2
        subject2.onNext("2")
        subject1.onNext("c")
        subject1.onCompleted()
    }
    
    func scan() {
        print("scan-------")
        Observable.of(1,2,3,4,5).scan(0){
            acum,elem in
            acum + elem
            }.subscribe(onNext:{print($0)}).disposed(by: disposeBag)
        
    }
    
    func groupBy() {
        print("groupby-------")
        Observable<Int>.of(0,1,2,3,4,5).groupBy { (element) -> String in
            return element % 2 == 0 ? "o" : "j"
            }.subscribe { (event) in
                switch event {
                case .next(let group):
                    group.asObservable().subscribe({ (event) in
                        print("key:\(group.key)  event:\(event)")
                    }).disposed(by: self.disposeBag)
                default:
                    print("default")
                }
        }.disposed(by: disposeBag)
    }
    
    func filter() {
        print("filter-------")
        Observable.of(2,30,22,5,60,3,40,9).filter {
            $0 > 10
            }.subscribe(onNext:{print($0)}).disposed(by: disposeBag)
    }
    
    func distinctUntilChanged() {
        print("distinctUntilChanged-------")
        Observable.of(1,2,3,1,1,4).distinctUntilChanged().subscribe(onNext:{print($0)}).disposed(by: disposeBag)
    }
    
    func single() {
        print("single-------")
        Observable.of(1,2,3,4).single{
            $0 == 2
            }.subscribe(onNext:{print($0)}).disposed(by: disposeBag)
        
        Observable.of("A", "B", "C", "D")
            .single()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    func elementAt() {
        print("elementAt-------")
        Observable.of(1,2,3,4).elementAt(2).subscribe(onNext:{print($0)}).disposed(by: disposeBag)
    }
    
    func ignoreElement() {
        print("ignoreElement-------")
        Observable.of(1,2,3,4).ignoreElements().subscribe{
            print($0)
        }.disposed(by: disposeBag)
    }
    
    func take() {
        print("take-------")
        Observable.of(1,2,3,4).take(2).subscribe(onNext:{print($0)}).disposed(by: disposeBag)
    }
    
    func takeLast() {
        print("takeLast-------")
       Observable.of(1,2,3,4,5).takeLast(2).subscribe(onNext:{print($0)}).disposed(by: disposeBag)
    }
    
    func skip() {
        print("skip-------")
        Observable.of(1,2,3,4).skip(2).subscribe(onNext:{print($0)}).disposed(by: disposeBag)
    }
    
    func sample() {
        print("sample-------")
        let source = PublishSubject<Int>()
        let notifier = PublishSubject<String>()
        
        source.sample(notifier).subscribe(onNext:{print($0)}).disposed(by: disposeBag)
        source.onNext(1)
        
        //让源序列接收接收消息
        notifier.onNext("A")//1
        
        source.onNext(2)
        
        //让源序列接收接收消息
        notifier.onNext("B")//2
        notifier.onNext("C")
        
        source.onNext(3)
        source.onNext(4)
        
        //让源序列接收接收消息
        notifier.onNext("D")//4
        
        source.onNext(5)
        
        //让源序列接收接收消息
        notifier.onCompleted()//5
    }
    
    func debounce() {//debounce 常用在用户输入的时候，不需要每个字母敲进去都发送一个事件，而是稍等一下取最后一个事件
        print("debounce-------")
        let times = [
            [ "value": 1, "time": 7 ],
            [ "value": 2, "time": 6 ],
            [ "value": 3, "time": 4 ],
            [ "value": 4, "time": 1 ],
            [ "value": 5, "time": 10 ],
            [ "value": 6, "time": 12 ]
        ]
        let date = Date()
        let dateString = dateConvertString(date: date)
        Observable.from(times).flatMap { item in
            return Observable.of(Int(item["value"]!)).delaySubscription(Double(item["time"]!), scheduler: MainScheduler.instance)
            }.debounce(2, scheduler: MainScheduler.instance).subscribe(onNext:{print("\(dateString):\($0)")}).disposed(by: disposeBag)
    }
    
    func amb() {//当传入多个 Observables 到 amb 操作符时，它将取第一个发出元素或产生事件的 Observable，然后只发出它的元素。并忽略掉其他的 Observables
        print("amb-------")
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        let subject3 = PublishSubject<Int>()
        
        subject1.amb(subject2).amb(subject3)
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        
        subject2.onNext(1)
        subject1.onNext(20)
        subject2.onNext(2)
        subject1.onNext(40)
        subject3.onNext(111)
        subject2.onNext(3)
        subject1.onNext(60)
        subject3.onNext(112)
        subject3.onNext(113)
    }
    
    func takeWhile() {//该方法依次判断 Observable 序列的每一个值是否满足给定的条件。 当第一个不满足条件的值出现时，它便自动完成。
        print("takeWhile-------")
        Observable.of(2,3,4,5,6).takeWhile {$0 < 4}.subscribe(onNext:{print($0)}).disposed(by: disposeBag)
    }
    
    func takeUnitl() {//如果 notifier 发出值或 complete 通知，那么源 Observable 便自动完成，停止发送事件
        print("takeUnitl-------")
        let source = PublishSubject<String>()
        let notifier = PublishSubject<String>()
        
        source.takeUntil(notifier).subscribe(onNext:{print($0)}).disposed(by: disposeBag)
        source.onNext("a")
        source.onNext("b")
        notifier.onNext("z")
        notifier.onNext("e")
        notifier.onNext("f")
    }
    
    func skipWhile() {//该方法用于跳过前面所有满足条件的事件。一旦遇到不满足条件的事件，之后就不会再跳过了。
        print("skipWhile-------")
        Observable.of(2,3,4,5,6).skipWhile { $0 < 4 }.subscribe(onNext: { print($0)}).disposed(by:disposeBag)
    }
    
    func skipUntil() {//与 takeUntil 相反的是。源 Observable 序列事件默认会一直跳过，直到 notifier 发出值或 complete 通知。
        print("skipUntil-------")
        let source = PublishSubject<Int>()
        let notifier = PublishSubject<Int>()
        
        source.skipUntil(notifier).subscribe(onNext:{print($0)}).disposed(by: disposeBag)
        source.onNext(1)
        source.onNext(2)
        source.onNext(3)
        
        
        //开始接收消息
        notifier.onNext(0)
        
        source.onNext(6)
        source.onNext(7)
        //仍然接收消息
        notifier.onNext(0)
        
        source.onNext(9)
    }
    
    func startWith() {
        print("startWith-------")
        Observable.of("2","3").startWith("a")
            .startWith("b").startWith("c").subscribe(onNext:{print($0)}).disposed(by: disposeBag)
    }
    
    func merge() {
        print("merge-------")
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        
        Observable.of(subject1, subject2).merge().subscribe(onNext:{print($0)}).disposed(by: disposeBag)
        subject1.onNext(20)
        subject1.onNext(40)
        subject2.onNext(1)
        subject1.onNext(80)
        subject1.onNext(100)
        subject2.onNext(1)
    }
    
    func zip() {
        print("zip-------")
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<String>()
        
        Observable.zip(subject1, subject2){
            "\($0)\($1)"
            }.subscribe(onNext:{print($0)}).disposed(by: disposeBag)
        
        subject1.onNext(1)
        subject2.onNext("A")
        subject1.onNext(2)
        subject2.onNext("B")
        subject2.onNext("C")
        subject2.onNext("D")
        subject1.onNext(3)
        subject1.onNext(4)
        subject1.onNext(5)
    }
    
    func combineLatest() {//但与 zip 不同的是，每当任意一个 Observable 有新的事件发出时，它会将每个 Observable 序列的最新的一个事件元素进行合并。
        print("combineLatest-------")
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<String>()
        
        Observable.combineLatest(subject1, subject2){
            "\($0)\($1)"
            }.subscribe(onNext:{print($0)}).disposed(by: disposeBag)
        
        subject1.onNext(1)
        subject2.onNext("A")
        subject1.onNext(2)
        subject2.onNext("B")
        subject2.onNext("C")
        subject2.onNext("D")
        subject1.onNext(3)
        subject1.onNext(4)
        subject1.onNext(5)
    }
    
    func withLatestFrom() {//该方法将两个 Observable 序列合并为一个。每当 self 队列发射一个元素时，便从第二个序列中取出最新的一个值。
        print("withLatestFrom-------")
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        
        subject1.withLatestFrom(subject2).subscribe(onNext:{print($0)}).disposed(by: disposeBag)
        subject1.onNext("A")
        subject2.onNext("1")
        subject1.onNext("B")
        subject1.onNext("C")
        subject2.onNext("2")
        subject1.onNext("D")
    }
    
    func switchLatest() {//比如本来监听的 subject1，我可以通过更改 variable 里面的 value 更换事件源。变成监听 subject2
        print("switchLatest-------")
        let subject1 = BehaviorSubject(value: "a")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject1)
        
        variable.asObservable().switchLatest().subscribe(onNext:{print($0)}).disposed(by: disposeBag)
        subject1.onNext("b")
        subject1.onNext("c")
        
        variable.value = subject2
        subject1.onNext("d")
        subject2.onNext("2")
        
        variable.value = subject1
        subject2.onNext("3")
        subject1.onNext("e")
    }
  
    func toArray() {
        Observable.of(1,2,3).toArray().subscribe(onNext:{print($0)}).disposed(by: disposeBag)
    }
    
    func reduce() {
        Observable.of(1,2,3,4,5).reduce(0, accumulator: +).subscribe(onNext:{print($0)}).disposed(by: disposeBag)
    }
    
    func concat() {//concat 会把多个 Observable 序列合并（串联）为一个 Observable 序列。并且只有当前面一个 Observable 序列发出了 completed 事件，才会开始发送下一个 Observable 序列事件。
        let subject1 = BehaviorSubject(value: 1)
        let subject2 = BehaviorSubject(value: 2)
        
        let variable = Variable(subject1)
        variable.asObservable().concat().subscribe(onNext:{print($0)}).disposed(by: disposeBag)
        
        subject2.onNext(2)
        subject1.onNext(1)
        subject1.onNext(1)
        subject1.onCompleted()
        
        variable.value = subject2
        subject2.onNext(2)
    }
    
    func dateConvertString(date:Date, dateFormat:String = "yyyy-MM-dd-HH-mm-ss-SSS") -> String {
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date.components(separatedBy: " ").first!
    }
}

extension UILabel {
    public var fontSize: Binder<CGFloat> {
        return Binder(self) { label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}

extension Reactive where Base: UILabel {
    public var fontSize: Binder<CGFloat> {
        return Binder(self.base) {label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}
