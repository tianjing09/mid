//
//  TJSnapViewController.swift
//  TJFramework
//
//  Created by jing 田 on 2019/9/19.
//  Copyright © 2019年 jing 田. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TJSnapViewController: TJBaseViewController {
    let bag = DisposeBag()
    lazy var view1: UIView = UIView()
    lazy var view2: UIView = UIView()
    lazy var view3: UIView = UIView()
    lazy var label: UILabel = UILabel()
    lazy var tf: UITextField = UITextField(frame: .zero)
    lazy var rxView: TJRX1View = TJRX1View(frame: .zero)
    var isShow = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scrollView = UIScrollView.init()
        scrollView.backgroundColor = .green
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.left.equalTo(10)
            make.top.equalTo(20)
            make.bottom.equalTo(-20)
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: 1500)
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true

        // Do any additional setup after loading the view.
        scrollView.addSubview(view1)
        scrollView.addSubview(view2)
        scrollView.addSubview(view3)
        scrollView.addSubview(rxView)
        print("ddd\(scrollView.frame.size.width)")
        view1.snp_makeConstraints { (make) in
            make.centerX.equalTo(scrollView)
            make.top.equalTo(0)
            make.height.width.equalTo(0)
        }
        view2.snp_makeConstraints { (make) in
            make.centerX.equalTo(scrollView)
            make.top.equalTo(view1.snp_bottom).offset(10)
            make.height.width.equalTo(200)
        }
        view3.snp_makeConstraints { (make) in
            make.centerX.equalTo(scrollView)
            make.top.equalTo(view2.snp_bottom).offset(10)
            make.height.width.equalTo(200)
        }
        
        rxView.snp_makeConstraints { (make) in
            make.centerX.equalTo(scrollView)
            make.top.equalTo(view3.snp_bottom).offset(10)
            make.height.width.equalTo(200)
        }
        
        scrollView.addSubview(tf)
        tf.backgroundColor = .white
        tf.snp_makeConstraints { (make) in
            make.top.equalTo(rxView.snp_bottom).offset(10)
            make.left.equalTo(10)
            make.width.equalTo(300)
            make.height.equalTo(40)
        }
        
        view1.backgroundColor = .red
        view2.backgroundColor = .purple
        view3.backgroundColor = .blue
        
        view1.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.width.equalTo(0)
            make.left.top.equalTo(10)
            make.height.equalTo(0)
        }
        label.backgroundColor = .yellow
        label.text = "fffffffff"
        
        let button = UIButton(type: .contactAdd)
        scrollView.addSubview(button)
        button.snp_makeConstraints { (make) in
            make.top.left.equalTo(10)
        }
        button.addTarget(self, action: #selector(updateC), for: .touchUpInside)
        
       addRX()
    }
    
    func addRX() {
        rxView.tapAction?.subscribe(onNext: { (text) in
            print("snap:\(text)")
        }).disposed(by: bag)
        
        tf.rx.text.bind(to: rxView.rx.content)
            .disposed(by: bag)

    }
    
//    override func updateViewConstraints() {
//        view1.snp.updateConstraints { (make) in
//            make.height.width.equalTo(200)
//        }
//        super.updateViewConstraints()
//    }
        
    @objc func updateC() {
        self.view.setNeedsUpdateConstraints()
        if isShow {
        UIView.animate(withDuration: 0.5) {
            self.view1.snp.updateConstraints { (make) in make.height.width.equalTo(200)
            }
            self.label.snp.updateConstraints { (make) in
                make.height.equalTo(40)
                make.width.equalTo(100)
            }
            self.view.layoutIfNeeded()
        }} else {
            UIView.animate(withDuration: 0.5) {
                self.view1.snp.updateConstraints { (make) in make.height.width.equalTo(0)
                }
                self.label.snp.updateConstraints { (make) in
                    make.height.equalTo(0)
                    make.width.equalTo(0)
                }
                self.view.layoutIfNeeded()
            }
        }
        isShow = !isShow
    }

}
