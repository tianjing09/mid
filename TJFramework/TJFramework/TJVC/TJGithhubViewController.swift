//
//  TJGithhubViewController.swift
//  TJFramework
//
//  Created by jing 田 on 2021/1/9.
//  Copyright © 2021 jing 田. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import ObjectMapper

class TJGithhubViewController: TJBaseViewController {
    var viewModel: TJGithubViewModel? = nil
    let bag = DisposeBag()
    var searchText = ""
    var searchLists:[TJGithubModel] = []
    var page = 1
    var isDownloading = false
    var state = TJGithubState()
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar(frame: .zero)
        sb.backgroundColor = .yellow
        sb.showsCancelButton = true
        return sb
    }()
    
    lazy var textField: UITextField = {
        let tf = UITextField(frame: .zero)
        tf.backgroundColor = .yellow
        return tf
    }()
    
    lazy var tableView: UITableView = {
        let tb = UITableView(frame: .zero, style: .plain)
        tb.backgroundColor = .green

        tb.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        //testCombine()//初始（都为“”）开始订阅
        //testCombineSignal()//双方都有值才开始订阅
        //testCombineDriver()//同signal
        //testCombineSignalToObservable()//同signal
        bindModel()
    }
    
    func testCombineSignalToObservable()  {
        Observable.combineLatest(searchBar.rx.text.orEmpty.changed.asSignal().asObservable(),textField.rx.text.orEmpty.changed.asSignal().asObservable()) { (text1, text2) -> String in
            print("1:\(text1)")
            print("2:\(text2)")
            return "\(text1)\(text2)"
        }.filter({ (t) -> Bool in
            return t.count > 0
        }).distinctUntilChanged().subscribe { (text) in
            print("combine:\(text)")
        }.disposed(by: bag)
    }
    
    func testCombine()  {
        Observable.combineLatest(searchBar.rx.text.orEmpty.asObservable(), textField.rx.text.orEmpty.asObservable()) { (text1, text2) -> String in
            print("1:\(text1)")
            print("2:\(text2)")
            return "\(text1)\(text2)"
        }.share(replay: 1).filter({ (t) -> Bool in
            return t.count > 0
        }).distinctUntilChanged().subscribe { (text) in
            print("combine:\(text)")
        }.disposed(by: bag)
    }
    
    func testCombineSignal() {
        Signal.combineLatest(searchBar.rx.text.orEmpty.changed.asSignal(),textField.rx.text.orEmpty.changed.asSignal()) { (text1, text2) -> String in
            print("1:\(text1)")
            print("2:\(text2)")
            return "\(text1)\(text2)"
        }.asObservable().filter({ (t) -> Bool in
            return t.count > 0
        }).distinctUntilChanged().subscribe { (text) in
            print("combine:\(text)")
        }.disposed(by: bag)
    }
    
    func testCombineDriver() {
        Driver.combineLatest(searchBar.rx.text.orEmpty.changed.asDriver(),textField.rx.text.orEmpty.changed.asDriver()) { (t1,t2) -> String in
            print("1:\(t1)")
            print("2:\(t2)")
            return "\(t1)\(t2)"
        }.asObservable().flatMapLatest({ (t) -> Observable<String> in
            return Observable.just(t)
        }).filter({ (t) -> Bool in
            return t.count > 0
        }).distinctUntilChanged().subscribe { (text) in
            print("combine:\(text)")
        }.disposed(by: bag)
    }
    
    func bindModel() {
       
       
        let searchSignal = searchBar.rx.text.orEmpty.asObservable().throttle(1, scheduler: MainScheduler.instance).map { [weak self](text) -> String in
            print("search signal")
            self!.searchText = text
            self!.page = 1
            self!.isDownloading = true
            self!.searchLists = []
            return text
        }
        
        let triggerObservable = tableView.rx.contentOffset.asObservable().flatMapLatest {[weak self] (_) -> Observable<Int> in
            if self!.tableView.isNearBottomEdge() && !self!.isDownloading {
                self!.page = self!.page + 1
                self!.isDownloading = true
                print("begin trigger")
                return Observable.just(self!.page)
            }
            //print("begin trigger")
            return Observable.empty()
        }.startWith(1)
        
       let lists = Observable.combineLatest(searchSignal,triggerObservable) { (text, page) -> TJGithubState in
            return TJGithubState(page: page, searchText: text)
        }.filter { (t) -> Bool in
            return t.searchText.count > 0
        }.distinctUntilChanged().flatMapLatest { (state) -> Observable<[TJGithubModel]> in
           return Service.requestWithText(state.searchText, page: state.page)
        }.map { (model) -> [TJGithubModel] in
            print(model.count)
            self.searchLists.append(contentsOf: model)
            print(self.searchLists.count)
            self.isDownloading = false
            return self.searchLists
        }
        
        DispatchQueue.main.async {
            lists.bind(to: self.tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element.htmlURL ?? "no url") @ row \(row)"
            }.disposed(by: self.bag)
        }
        

        
//        Observable.combineLatest(searchSignal,triggerObservable) { (text, page) -> TJGithubState in
//            return TJGithubState(page: page, searchText: text)
//        }.filter { (t) -> Bool in
//            return t.searchText.count > 0
//        }.distinctUntilChanged().subscribe { (state) in
//            print("state:\(state)")
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                self.isDownloading = false
//            }
//        }.disposed(by: bag)

                
//                Signal.combineLatest(searchSignal, triggerSignal) { (text, page) -> String in
//                    return "\(text):\(page)"
//                }.asObservable()
//                .subscribe { (text) in
//                    print(text)
//                } .disposed(by: bag)
    }
    
    func testTrigger()  {
        let triggerSignal = tableView.rx.contentOffset.asDriver().flatMapLatest {[weak self] (_) -> SharedSequence<SignalSharingStrategy, Int> in
            if self!.tableView.isNearBottomEdge() && !self!.isDownloading {
                return Signal.just(self!.page + 1)
            }
            return Signal.empty()
        }

        triggerSignal.asObservable().subscribe { (signal) in
            self.isDownloading = true
            print("sss:\(signal)")
        }.disposed(by: bag)
    }
    
    
    func testSearchBar()  {
//        searchBar.rx.text.orEmpty.asObservable().throttle(2, scheduler: MainScheduler.instance).map { [weak self] (text)  -> String in
//            self!.searchText = text
//            self!.sss()
//            return text
//        }.subscribe { (text) in
//            print(text)
//        } .disposed(by: bag)
        
        searchBar.rx.text.orEmpty.changed.asSignal().throttle(2).asObservable().map { [weak self] (text)  -> String in
                self!.searchText = text
                self!.sss()
                return text
            }.subscribe { (text) in
                print(text)
            } .disposed(by: bag)

    }
    
    func sss()  {
        print("ddd:\(searchText)")
    }
    
    func addSubviews() {
        self.view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(20)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(searchBar.snp_bottom).offset(10)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(textField.snp_bottom).offset(10)
            make.bottom.equalTo(-10)
        }
        
//        DispatchQueue.main.async { [weak self] in
//            self!.refresh()
//        }
}

    func refresh()  {
        let items = Observable.just(
            (0..<50).map { "\($0)" }
        )

        items
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .disposed(by: bag)
    }
    
    }

//        searchSignal.asObservable().flatMapLatest { (text) -> Observable<[TJGithubModel]> in
//            print("begin request")
//            return Service.requestWithText(text, page: "1")
//        }.map {[weak self] (list) -> [TJGithubModel] in
//            self!.searchLists.append(contentsOf: list)
//            return self!.searchLists
//        }.subscribe { [weak self](model) in
//            self!.isDownloading = false
//            print(self!.searchLists.count)
//        }.disposed(by: bag)

        
//                let triggerSignal = tableView.rx.contentOffset.asObservable().flatMapLatest {[weak self] (_) -> SharedSequence<SignalSharingStrategy, Int> in
//                    if self!.tableView.isNearBottomEdge() && !self!.isDownloading {
//                        self!.page = self!.page + 1
//                        self!.isDownloading = true
//                        return Signal.just(self!.page)
//                    }
//                    return Signal.empty()
//                }
        
//        triggerSignal.asObservable().flatMapLatest {[weak self] (page) -> Observable<[TJGithubModel]> in
//            print("begin request")
//            return Service.requestWithText(self!.searchText, page: "\(page)")
//        }.map {[weak self] (list) -> [TJGithubModel] in
//            self!.searchLists.append(contentsOf: list)
//            return self!.searchLists
//        }.subscribe { [weak self](model) in
//            self!.isDownloading = false
//            print(self!.searchLists.count)
//        }.disposed(by: bag)
        
//        Observable.combineLatest(searchSignal.asObservable(),triggerSignal.asObservable()).flatMap { (text,page) -> Observable<[TJGithubModel]> in
//            self.isDownloading = true
//            return Service.requestWithText(text, page: "\(page)")
//        }.subscribe { (list) in
//            print(list)
//        }.disposed(by: bag)
