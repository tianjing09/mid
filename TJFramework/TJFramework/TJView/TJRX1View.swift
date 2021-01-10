//
//  TJRX1View.swift
//  TJFramework
//
//  Created by jing 田 on 2021/1/10.
//  Copyright © 2021 jing 田. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

extension Reactive where Base: TJRX1View {
    var content: Binder<String?> {
        return Binder(base) { rxView, text in
            if let t = text {
              rxView.title1.text = "\(t)111"
              rxView.title2.text = "\(t)222"
            }
        }
    }
}

class TJRX1View: UIView {
    let bag = DisposeBag()
    var tapAction: Observable<String>?
    
    private lazy var okButton: UIButton = {
       let button = UIButton(type: .custom)
        button.frame = .zero
        button.setTitle("ok", for: .normal)
        button.backgroundColor = .orange
        return button
    }()
    
     lazy var title1: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.text = "111"
        label.backgroundColor = .yellow
        return label
    }()
    
     lazy var title2: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.text = "222"
        label.backgroundColor = .green
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubviews()
        self.addRX()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addRX() {
//        okButton.rx.tap.subscribe { (_) in
//            print("add rx")
//        }.disposed(by: bag)
        tapAction = okButton.rx.tap.asObservable().map { (_) -> String in
            if let s1 = self.title1.text, let s2 = self.title2.text {
               return s1 + s2
            }
            return ""
        }
    }
    
    func addSubviews() {
        self.addSubview(okButton)
        okButton.snp_makeConstraints { (make) in
            make.top.left.equalTo(10)
            make.width.equalTo(50)
            make.height.equalTo(self.snp_height).multipliedBy(0.2)
        }
        
        self.addSubview(title1)
        title1.snp_makeConstraints { (make) in
            make.top.equalTo(self.okButton.snp_bottom).offset(10)
            make.left.equalTo(10)
            make.width.equalTo(100)
            make.height.equalTo(self.snp_height).multipliedBy(0.2)
        }
        self.addSubview(title2)
        title2.snp_makeConstraints { (make) in
            make.top.equalTo(self.title1.snp_bottom).offset(10)
            make.left.equalTo(10)
            make.width.equalTo(100)
            make.height.equalTo(self.snp_height).multipliedBy(0.2)
        }
    }
    
}
