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
        var b = self.block(number: 3) { (a) in
            a * a
        }
        print("bbbb\(b)")
        // Do any additional setup after loading the view.
        
        TJService.postRequestWithParam(param) { (response, result) in
            if (result == .success) {
                if let dic = response,let tokenId = dic["statusMessage"],let t = tokenId as? String {
                    
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
    //54321
    func bubbleSort(originalArray:inout [Int]) -> [Int] {
        let count = originalArray.count
        for i in 0...count - 2 {
            var isChanged = false
            let end = count - i - 2
            for j in 0...end {
                if originalArray[j] > originalArray[j+1] {
                    isChanged = true
                    (originalArray[j],originalArray[j+1]) = (originalArray[j+1],originalArray[j])
                }
            }
            if isChanged == false {
               break
            }
        }
        return originalArray
    }
    
    func block(number:Int, multi:@escaping(Int) -> Void) -> Int{
        DispatchQueue.main.asyncAfter(deadline: .now()+2.5) {
            multi(number)
            print("mmmmm")
        }
        return 8
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
