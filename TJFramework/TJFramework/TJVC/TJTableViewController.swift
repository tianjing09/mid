//
//  TJTableViewController.swift
//  TJFramework
//
//  Created by jing 田 on 2021/4/17.
//  Copyright © 2021 jing 田. All rights reserved.
//

import UIKit

class TJTableViewController: TJBaseViewController, UITableViewDelegate, UITableViewDataSource {
    lazy var table:UITableView = {
     
            let table = UITableView(frame: CGRect(x: 10, y: 20, width: 380, height: 10000),style: UITableView.Style.plain)
     
            table.backgroundColor = UIColor.lightGray
        table.register(SubNormalCell.self, forCellReuseIdentifier: "sub")
        table.register(Sub1NormalCell.self, forCellReuseIdentifier: "sub1")
            return table
     
        }()
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginScrollView = UIScrollView()
        view.addSubview(loginScrollView)
        loginScrollView.frame = CGRect(x: 10, y: 50, width: 400, height: 600)
        loginScrollView.backgroundColor = .systemPink
        // 可以滚动的区域
        loginScrollView.contentSize = CGSize(width: 300, height: 10100)
        // 设置是否翻页
//        loginScrollView.isPagingEnabled = true
        // 显⽰示⽔水平滚动条
        loginScrollView.showsHorizontalScrollIndicator = true
        // 显⽰示垂直滚动条
        loginScrollView.showsVerticalScrollIndicator = true
        // 滚动条样式
        loginScrollView.indicatorStyle = UIScrollView.IndicatorStyle.black
        // 设置回弹效果
        loginScrollView.bounces = false
        // 设置scrollView可以滚动
        loginScrollView.isScrollEnabled = true
        // Do any additional setup after loading the view.
        
        
        loginScrollView.addSubview(table)
    
               table.delegate = self
        
               table.dataSource = self
      


}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 100
        }
        
//        func numberOfSections(in tableView: UITableView) -> Int {
//            return 5
//        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let randomNumber:Int = Int(arc4random() % 2)
        var type = "sub1"
        if randomNumber == 1 { type = "sub" }
        //let cell = NormalCell .cellWithData(style: .default, data: ["type" : type])
        let cell = tableView.dequeueReusableCell(withIdentifier: "sub")!
            cell.textLabel?.text = String(format: "行：%d", indexPath.row+1)//String(indexPath.row)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            print(indexPath.row+1)
            return cell
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
}
