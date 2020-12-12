//
//  ViewController.swift
//  TJFramework
//
//  Created by jing 田 on 2018/11/15.
//  Copyright © 2018年 jing 田. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let button = UIButton(type: .contactAdd)
        button.frame = CGRect(x: 50, y: 150, width: 50, height: 50)
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(push), for: .touchUpInside)
    }

    @objc private func push() {
//        self.present(TJStructureViewController(), animated: true) {
//            
//        }
        self.navigationController?.pushViewController(TJStructureViewController(), animated: true)
    }
}

