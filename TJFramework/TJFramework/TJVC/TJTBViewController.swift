//
//  TJTBViewController.swift
//  TJFramework
//
//  Created by jing 田 on 2021/4/21.
//  Copyright © 2021 jing 田. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxDataSources

class TJTBViewController: TJBaseViewController, UIScrollViewDelegate, UITableViewDelegate {
    lazy var tableView: UITableView = {
        let table = UITableView.init()
        table.register(NormalCell.self, forCellReuseIdentifier: "musicCell")
        table.backgroundColor = .yellow
        return table
    }()
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPurple
        return view
    }()
    
    
    let disposeBag = DisposeBag()
    let musicListViewModel = MusicListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.equalTo(20)
            make.bottom.right.equalTo(-20)
        }
        tableView.delegate = self
        
        let items = Observable.just([
                        SectionModel(model: "我喜欢的语言", items: [
                                        "你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年",
                            "C",
                                        "你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年",
                            "Go",
                                        "你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年"]),
            SectionModel(model: "我喜欢的语言", items: [
                            "你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年",
                "C",
                            "你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年",
                "Go",
                            "你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年"]),
                        SectionModel(model: "我讨厌的语言", items: [
                            "你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年",
                            "你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年你曾是少年",
                            ])
                        ])

             //将数据源数据绑定到tableView上
//        musicListViewModel.data
//            .bind(to: tableView.rx.items(cellIdentifier:"musicCell")) { _, music, cell in
//                cell.textLabel?.numberOfLines = 0
//                cell.textLabel?.text = music.name
//                cell.detailTextLabel?.text = music.singer
//            }.disposed(by: disposeBag)
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell:{ dataSource, tv, indexPath, element in
//                        let cell = tv.dequeueReusableCell(withIdentifier: "musicCell") as! NormalCell
            let cell = NormalCell.init(style: .default, reuseIdentifier: "musicCell")
            cell.title1.text = "\(indexPath.row): \(element)"
                        return cell
                    })

        
//        musicListViewModel.data.bind(to:  tableView.rx.items(cellIdentifier: "musicCell", cellType: NormalCell.self)) { (row, element, cell) in
//            cell.title1.text = element.name
//        }
//        .disposed(by: disposeBag)
        dataSource.titleForHeaderInSection = {
                        ds, index in
                        return ds.sectionModels[index].model
                    }

        items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            print(scrollView.contentOffset.y)
            if scrollView.contentOffset.y < 0, scrollView.contentOffset.y > -30 {
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            } else if scrollView.contentOffset.y > 30 {
                scrollView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
            } else if scrollView.contentOffset.y < 0, scrollView.contentOffset.y <= 30 {
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       print("DidEndDecelerating")
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }


    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
       print("DidEndScrollingAnimation")
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("WillEndDragging")
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("DidEndDragging")
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    

}
