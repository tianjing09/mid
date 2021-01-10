//
//  TJStructureViewController.swift
//  TJFramework
//
//  Created by jing 田 on 2018/11/16.
//  Copyright © 2018年 jing 田. All rights reserved.
//

import UIKit

class TJStructureViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        cell.textLabel?.text = self.menus[indexPath.row]["name"]
        if self.selectVcIndex == indexPath.row {
            cell.contentView.backgroundColor = .red
        } else {
            cell.contentView.backgroundColor = .white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectVcIndex = indexPath.row
        self.resetVc()
    }
    
    var selectVcIndex = 0
    var isMenu: Bool = false
    var vcs:[TJBaseViewController] = []
    var menus:[[String:String]] = []
    var type:Int = 1
    lazy var menuTabel: UITableView = {
        let table = UITableView.init(frame: CGRect(x: 0, y: 80, width: 200, height: self.viewHeight - 50 - 80 - 33), style: .plain)
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        return table
    }()
    lazy var viewWidth: CGFloat = {
        return self.view.bounds.size.width
    }()
    
    lazy var viewHeight: CGFloat = {
        return self.view.bounds.size.height
    }()
    lazy var bgView: UIView = {
        let view = UIView.init(frame: CGRect(x: -200, y: 33, width:self.viewWidth + 200, height: self.viewHeight - 33))
        view.backgroundColor = .black
        view.isUserInteractionEnabled = true
        view.addSubview(self.leftBgView)
        view.addSubview(self.rightBgView)
        return view
    }()
    
    lazy var leftBgView: UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 200, height: self.viewHeight - 33))
        view.backgroundColor = .yellow
        view.isUserInteractionEnabled = true
        view.addSubview(self.menuTabel)
        return view
    }()
    
    lazy var rightBgView: UIView = {
        let view = UIView.init(frame: CGRect(x: 200, y: 0, width: self.viewWidth, height: self.viewHeight - 33))
        view.backgroundColor = .gray
        //view.addSubview(self.topBgView)
        view.addSubview(self.bottomBgView)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var topBgView: UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: self.viewWidth, height: 44))
        view.backgroundColor = .green
        view.addSubview(self.menuButton)
        view.addSubview(self.resetButton)
        return view
    }()
    
    lazy var bottomBgView: UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 44, width: self.viewWidth, height: self.viewHeight - 44 - 33))
        view.backgroundColor = .white
        return view
    }()
    
    lazy var menuButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 10, y: 0, width: 60, height: 44))
        button.setTitle("menu", for: .normal)
        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(menu), for: .touchUpInside)
        return button
    }()
    
    lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(menu))
        return button
    }()
    
    lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(reset))
        return button
    }()
    
    
    lazy var resetButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 200, y: 0, width: 60, height: 44))
        button.setTitle("reset", for: .normal)
        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(reset), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.bgView)
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationItem.title = "TJStructure"
        self.addGesture()
        self.freshStructure()
        // Do any additional setup after loading the view.
    }
    
    func addGesture() {
//        let swipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(swipe))
//        swipeGesture.direction = .left
//        self.leftBgView.addGestureRecognizer(swipeGesture)
//
//        let swipeGesture0 = UISwipeGestureRecognizer.init(target: self, action: #selector(swipe))
//        swipeGesture0.direction = .right
//        self.leftBgView.addGestureRecognizer(swipeGesture0)
//
//        let swipeGesture1 = UISwipeGestureRecognizer.init(target: self, action: #selector(swipe))
//        swipeGesture1.direction = .right
//        self.rightBgView.addGestureRecognizer(swipeGesture1)
//
//        let swipeGesture11 = UISwipeGestureRecognizer.init(target: self, action: #selector(swipe))
//        swipeGesture11.direction = .left
//        self.rightBgView.addGestureRecognizer(swipeGesture11)
        
        let swipeGesture1 = UISwipeGestureRecognizer.init(target: self, action: #selector(swipe))
        swipeGesture1.direction = .right
        self.bgView.addGestureRecognizer(swipeGesture1)
        
        let swipeGesture11 = UISwipeGestureRecognizer.init(target: self, action: #selector(swipe))
        swipeGesture11.direction = .left
        self.bgView.addGestureRecognizer(swipeGesture11)
    }
    
    func freshStructure() {
        self.vcs = []
        self.menus = []
        for subView in  self.bottomBgView.subviews {
            subView.removeFromSuperview()
        }
        self.selectVcIndex = 0
        if (type == 1) {
            self.vcs = [TJMVVMViewController(),TJGithhubViewController(),TJRxRestartViewController(),TJRxDifficultViewController(),TJOneViewController(), TJTwoViewController(), TJThreeViewController(),TJSnapViewController(),TJRxSwiftViewController()]
            self.menus =
                   [["name":"mvvm"],["name":"rgithub"],["name":"rxRestart"],
                  ["name":"rxdifficult"],["name":"colorfulBar"],["name":"mutiSelect"],["name":"alamofire"],["name":"snapkit"],["name":"RxSwift"]]
        } else {
            self.vcs = [TJOneViewController(), TJThreeViewController(), TJTwoViewController()]
            self.menus = [["name":"one"],["name":"three"],["name":"two"]]
        }
        self.resetVc()
    }
    
    @objc func reset() {
        if (self.selectVcIndex == 0) {
//           let randomNumber = Int(arc4random() % 3)
//           self.type = randomNumber
           if self.type == 1 {
             self.type = 2
           } else {
             self.type = 1
           }
            
           self.freshStructure()
        }
    }
    
    func resetVc() {
        self.menuTabel.reloadData()
        let vc = self.vcs[self.selectVcIndex]
        vc.view.frame = CGRect(x: 0, y: 0, width: self.viewWidth, height: self.viewHeight - 44 - 33)
        self.bottomBgView.addSubview(vc.view)
        self.bottomBgView .bringSubviewToFront(vc.view)
    }
    
    @objc func menu(){
        if self.bgView.frame.origin.x == 0 {
            UIView.animate(withDuration: 1.0) {
                self.bgView.frame = CGRect(x: -200, y: 33, width: self.viewWidth + 200, height: self.viewHeight)
            }
        } else {
            UIView.animate(withDuration: 1.0) {
                self.bgView.frame = CGRect(x: 0, y: 33, width: self.viewWidth + 200, height: self.viewHeight)
            }
        }
    }
    
    @objc func swipe(gesture:UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            UIView.animate(withDuration: 1.0) {
                self.bgView.frame = CGRect(x: -200, y: 33, width: self.viewWidth + 200, height: self.viewHeight)
            }
        } else {
            UIView.animate(withDuration: 1.0) {
                self.bgView.frame = CGRect(x: 0, y: 33, width: self.viewWidth + 200, height: self.viewHeight)
            }
        }
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
