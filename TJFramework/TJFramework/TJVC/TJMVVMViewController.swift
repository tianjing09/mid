//
//  TJMVVMViewController.swift
//  TJFramework
//
//  Created by jing 田 on 2021/1/10.
//  Copyright © 2021 jing 田. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import ObjectMapper

class TJMVVMViewController: TJBaseViewController {
    var viewModel: TJGithubViewModel? = nil
    let bag = DisposeBag()
    
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
        bindModel()
    }
    
    func bindModel() {
        let searchSignal = searchBar.rx.text.orEmpty.asObservable()

        let triggerObservable =             self.tableView.rx.contentOffset.asObservable().flatMapLatest { (_) -> Observable<Int> in
            if  self.tableView.isNearBottomEdge() {
                //print("11111")
                return Observable.just(1)
            }
           // print("empty")
            return Observable.empty()
        }.startWith(1209)
        
        viewModel = TJGithubViewModel(input: (searchText: searchSignal, loadPageTrigger: triggerObservable))
        
        DispatchQueue.main.async {
            self.viewModel?.searchListDriver.bind(to: self.tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element.htmlURL ?? "no url") @ row \(row)"
            }.disposed(by: self.bag)
        }
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

}
