//
//  NormalCell.swift
//  TJFramework
//
//  Created by jing 田 on 2021/4/17.
//  Copyright © 2021 jing 田. All rights reserved.
//

import UIKit
import SnapKit

class NormalCell: UITableViewCell {
    lazy var title1: UILabel = {
       let label = UILabel.init(frame: .zero)
       label.text = "111"
        label.numberOfLines = 0
       label.backgroundColor = .yellow
       return label
   }()
    lazy var backView: UIView = {
        let view = UIView.init()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.purple.cgColor
        view.layer.cornerRadius = 5
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style:style,reuseIdentifier:reuseIdentifier)
        contentView.addSubview(backView)
        backView.addSubview(title1)
        backView.snp.makeConstraints { (make) in
            make.top.left.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.right.equalTo(-50)
        }
        
        title1.snp.makeConstraints { (make) in
            make.top.left.top.equalTo(10)
            make.right.bottom.equalTo(-10)
        }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    static func cellWithData(style:
                                UITableViewCell.CellStyle, data: [String : String]) -> NormalCell {
        if data["type"] == "sub" {
            return SubNormalCell.init(style: style, reuseIdentifier: "sub")
        } else {
            return Sub1NormalCell.init(style: style, reuseIdentifier: "sub1")
        }
    }
    
}
