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
