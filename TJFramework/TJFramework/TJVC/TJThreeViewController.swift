//
//  TJThreeViewController.swift
//  TJFramework
//
//  Created by jing 田 on 2018/11/19.
//  Copyright © 2018年 jing 田. All rights reserved.
//

import UIKit

class TJThreeViewController: TJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue

        // Do any additional setup after loading the view.
        let param = ["module":"login","mudid":"XC134054","tokenId":"test mode"];
        TJService.postRequestWithParam(param) { (response, result) in
            if (result == .success) {
                if let dic = response,let tokenId = dic["statusMessage"],let t = tokenId as? String {
                    let param1 = ["module":"getuserinfo","mudid":"XC134054","tokenId":t, "isOffline":"N"];
                    TJService.requestWithParam(param1, method: .post) { (response1, result1) in
                        if result1 == .success,let dic1 = response1?["resultData"],let data = dic1 as? [String:Any] {
                            let canUseApps = data["canUseApp"]
                            print(canUseApps ?? "null")
                        }
                    }
                }
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
