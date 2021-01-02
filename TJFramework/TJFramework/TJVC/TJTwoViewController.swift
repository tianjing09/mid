//
//  TJTwoViewController.swift
//  TJFramework
//
//  Created by jing 田 on 2018/11/19.
//  Copyright © 2018年 jing 田. All rights reserved.
//

import UIKit

class TJTwoViewController: TJBaseViewController, TJMutiSelectViewDelegate {
    func didOk(selectData: [String]) {
        print(selectData)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
        // Do any additional setup after loading the view.
        let selectView = TJMutiSelectView.init(frame: CGRect(x: 50, y: 50, width: 200, height: 300))
        selectView.delegate = self
        self.view.addSubview(selectView)
        selectView.refreshView(data: ["1","2","3","4","5"])
        _ = Test1()
        _ = Test2(a: "1", b: 2)
    }
    
}

class Test1 {
    var a: String = ""
    var  b: Int?
//    init(_ a: String) {
//        self.a = a
//    }
}

struct Test2 {
    var a: String
    var  b: Int
}

