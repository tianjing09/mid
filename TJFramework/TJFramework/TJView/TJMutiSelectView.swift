//
//  TJMutiSelectView.swift
//  TJFramework
//
//  Created by jing 田 on 2018/11/23.
//  Copyright © 2018年 jing 田. All rights reserved.
//

import UIKit
protocol TJMutiSelectViewDelegate {
    func didOk(selectData:[String]) -> Void
}

class TJMutiSelectView: UIView, UITableViewDelegate, UITableViewDataSource {
    var delegate :TJMutiSelectViewDelegate?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.processData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.textLabel?.text = self.processData[indexPath.row]["name"]
        if (self.processData[indexPath.row]["selected"] == "1") {
            cell.contentView.backgroundColor = .green
        } else {
            cell.contentView.backgroundColor = .white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var data = self.processData[indexPath.row]
        data["selected"] = ((data["selected"] == "1") ? "0" : "1")
//        self.processData.remove(at: indexPath.row)
//        self.processData.insert(data, at: indexPath.row)
        self.processData.replaceSubrange(indexPath.row...indexPath.row, with: [data])
        self.tableView.reloadData()
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var maxHeight:CGFloat = 0
    private var width:CGFloat = 0
    private var height:CGFloat = 0
    private var processData = [[String:String]]()
    
    private lazy var tableView:UITableView = {
        let table = UITableView.init(frame: CGRect(x: 0, y: 0, width: width, height: height - 30), style: .plain)
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
        return table
    }()
    
    private lazy var okButton:UIButton = {
       let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: height - 30, width: width, height: 30)
        button.setTitle("ok", for: .normal)
        button.addTarget(self, action: #selector(ok), for: .touchUpInside)
        button.backgroundColor = .orange
        return button
    }()
    
    @objc private func ok() {
        var selectData = [String]()
        for data in self.processData {
            if data["selected"] == "1" {
              selectData.append(data["name"] ?? "")
            }
        }
        self.delegate?.didOk(selectData: selectData)
        self.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
        self.width = frame.size.width
        self.height = frame.size.height
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.addSubview(self.tableView)
        self.addSubview(self.okButton)
    }
    
    func refreshView(data:[String], selectData:[String] = []) {
        self.isHidden = false
        self.processData.removeAll()
        for name in data {
            if selectData.contains(name) {
               self.processData.append(["name":name,"selected":"1"])
            } else {
               self.processData.append(["name":name,"selected":"0"])
            }
        }
        self.tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
