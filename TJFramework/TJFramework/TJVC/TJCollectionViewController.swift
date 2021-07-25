//
//  TJCollectionViewController.swift
//  TJFramework
//
//  Created by jing 田 on 2021/5/14.
//  Copyright © 2021 jing 田. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxDataSources

class TJCollectionViewController: TJBaseViewController {
    var collectionView:UICollectionView!
    let disposeBag = DisposeBag()
    var db = DisposeBag()
    lazy var button: UIButton = UIButton(type: .contactAdd)
    lazy var button1: UIButton = UIButton(type: .detailDisclosure)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //定义布局方式以及单元格大小
               let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: view.frame.size.width - 50, height: 200)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 20
       // flowLayout.sectionInset = 
                
               //创建集合视图
        self.collectionView = UICollectionView(frame: .zero,
                                                      collectionViewLayout: flowLayout)
               self.collectionView.backgroundColor = UIColor.white
        self.collectionView.isUserInteractionEnabled = true
        self.collectionView.isPagingEnabled = true
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
                
               //创建一个重用的单元格
               self.collectionView.register(TJCollectionViewCell.self,
                                            forCellWithReuseIdentifier: "Cell")
               self.view.addSubview(self.collectionView!)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.right.left.equalTo(0)
            make.height.equalTo(200)
        }
               //初始化数据
               let items = Observable.just([
                   "Swift",
                   "PHP",
                   "Ruby",
                   "Java",
                   "C++",
                   ])

        // Do any additional setup after loading the view.
        items.bind(to: collectionView.rx.items) { (collectionView, row, element) in
                    let indexPath = IndexPath(row: row, section: 0)
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                    for: indexPath) as! TJCollectionViewCell
                    cell.label.text = "\(row)：\(element)"
                    return cell
                }
                .disposed(by: disposeBag)
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(300)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        view.addSubview(button1)
        button1.snp.makeConstraints { (make) in
            make.left.equalTo(220)
            make.top.equalTo(300)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        button.rx.tap.subscribe { (_) in
            print("aa")
        }.disposed(by: DisposeBag())
        
        button1.rx.tap.subscribe { [weak self](_) in
            self?.db = DisposeBag()
        }.disposed(by: disposeBag)
        

    }
    
   
    

    

}
