//
//  TJCollectionViewCell.swift
//  TJFramework
//
//  Created by jing 田 on 2021/5/14.
//  Copyright © 2021 jing 田. All rights reserved.
//

import UIKit
import SnapKit

class TJCollectionViewCell: UICollectionViewCell {
    lazy var label: UILabel = UILabel(frame: CGRect.zero)
    override init(frame: CGRect) {
            super.init(frame: frame)
             
            //背景设为橙色
            self.backgroundColor = UIColor.orange
             
            //创建文本标签
            
        label.textColor = .green
        label.backgroundColor = .red
            label.textAlignment = .center
            self.contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.left.equalTo(80)
            make.bottom.right.equalTo(-80)
        }
        }
         
        override func layoutSubviews() {
            super.layoutSubviews()
          
        }
     
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
