//
//  TJRXDemoViewController.swift
//  TJFramework
//
//  Created by jing 田 on 2021/1/7.
//  Copyright © 2021 jing 田. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

extension UIScrollView {
    func  isNearBottomEdge(edgeOffset: CGFloat = 40.0) -> Bool {
        if self.contentSize.height == 0 {
            return false
        }
       return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}

class TJRXDemoViewController: TJBaseViewController {//, 
    var viewModel: TJGithubViewModel? = nil
    let bag = DisposeBag()
    var searchText = ""
    var lists:[[NSString: Any]] = []
    var page = 1
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar(frame: .zero)
        sb.backgroundColor = .yellow
        sb.showsCancelButton = true
        return sb
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
        let list1 = searchBar.rx.text.orEmpty.asDriver().throttle(1).flatMapLatest { text in
            return Service.requestWithText(text, page: 1).asDriver(onErrorJustReturn: [])
        }

        list1.drive(tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, element, cell in
            cell.textLabel?.text = element.htmlURL as? String
        }.disposed(by: bag)
        
//       let trigger =  tableView.rx.contentOffset.asDriver().flatMap { _ in
//            self.tableView.isNearBottomEdge() ? Signal.just(()) : Signal.empty()
//       }
        let trigger =  tableView.rx.contentOffset.asDriver().flatMapLatest {[weak self] (_) -> SharedSequence<SignalSharingStrategy, ()> in
            if self!.tableView.isNearBottomEdge()  {
                return Signal.just(())
            }
            return Signal.empty()
        }
        
        let list = trigger.flatMapLatest { _ in
            //page = page + 1
            return Service.requestWithText(self.searchText, page: self.page).asDriver(onErrorJustReturn: [])
        }
        
        
//        let list = searchBar.rx.text.orEmpty.changed.asSignal().throttle(1).flatMapLatest { text in
//            return Service.requestWithText(text, page: "1").asDriver(onErrorJustReturn: [])
//        }
        
        list.drive(tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, element, cell in
            cell.textLabel?.text = element.htmlURL as? String
        }.disposed(by: bag)
//        searchBar.rx.text.orEmpty.subscribe(onNext: { text in
//            Service.requestWithText(text, page: "1").subscribe(onNext: { data in
//               print(data)
//            }, onError: { (error) in
//                print(error)
//            }).disposed(by: self.bag)
//        }).disposed(by: bag)
        
//        searchBar.rx.text.orEmpty.asObservable().flatMap{ text in
//            return Service.requestWithText(text, page: "1")
//        }
        
//           let list =  searchBar.rx.text.orEmpty
//            .throttle(2, scheduler: MainScheduler.instance).distinctUntilChanged()
//            .flatMapLatest { (text) -> Observable<[[String:Any]]> in
//                if text.isEmpty {
//                    return .just([])
//                }
//                return Service.requestWithText(text, page: "1")
//            }.observeOn(MainScheduler.instance)
//
//        list.bind(to:tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, element, cell in
//            cell.textLabel?.text = element["html_url"] as? String
//        }.disposed(by: bag)
        

//        

        
        // Do any additional setup after loading the view.
    }
    
    func addSubviews() {
        self.view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(20)
            make.height.equalTo(40)
        }
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(searchBar.snp_bottom).offset(10)
            make.bottom.equalTo(-10)
        }
    }
    
    func initViewModel() {
        
       
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
