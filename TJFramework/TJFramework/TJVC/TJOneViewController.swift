//
//  TJOneViewController.swift
//  TJFramework
//
//  Created by jing 田 on 2018/11/19.
//  Copyright © 2018年 jing 田. All rights reserved.
//

import UIKit

class TJOneViewController: TJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        let barView = TJColorfulBar.init(frame: CGRect(x: 50, y: 50, width: 300, height: 400))
        let data = [["10","30","50"],["","","50"],["70","10","40"],["20","30",""],["40","40","20"],["10","60","30"],["10","90","50"]]
        barView.barData = data
        barView.maxValue = 150
        barView.colors = [.magenta, .yellow, .orange]
        barView.backgroundColor = .white
        self.view.addSubview(barView)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
             barView.refreshView()
        }
       
        let circleView = TJCircleView.init(frame: CGRect(x: 50, y: 460, width: 300, height: 300))
        circleView.backgroundColor = .white
        self.view.addSubview(circleView)
        circleView.colors = [.magenta, .green, .orange, .blue]
        let cdata = ["80","90","50","70"]
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            circleView.refreshView(data: cdata)
        }
        
        // Do any additional setup after loading the view.
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
