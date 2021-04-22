//
//  SubNormalCell.swift
//  TJFramework
//
//  Created by jing 田 on 2021/4/20.
//  Copyright © 2021 jing 田. All rights reserved.
//

import UIKit

class SubNormalCell: NormalCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            
            super.init(style:style,reuseIdentifier:reuseIdentifier)
            setupBasic()
            
        }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBasic() {
        self.contentView.addSubview(hintLabel)
        let imageView = UIImageView(image: UIImage(named: "laopo"))
        imageView.frame = CGRect(x: 100, y: 3, width: 94, height: 94)
        self.contentView.addSubview(imageView)
        
        let imageView1 = UIImageView(image: UIImage(named: "laopo"))
        imageView1.frame = CGRect(x: 210, y: 3, width: 94, height: 94)
        self.contentView.addSubview(imageView1)
    }
    
    public var hintLabel:UILabel = {
            
            let hintLabel = UILabel()
        hintLabel.frame = CGRect(x: 10, y: 2, width: 40, height: 38)
            hintLabel.font = UIFont.systemFont(ofSize: 15)
            hintLabel.textAlignment = .center
            hintLabel.textColor = UIColor.green
     
            return hintLabel
            
        }()
    

}
