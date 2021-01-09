//
//  TJGithubViewModel.swift
//  TJFramework
//
//  Created by jing 田 on 2021/1/7.
//  Copyright © 2021 jing 田. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import ObjectMapper

class TJGithubModel: Mappable {
    var htmlURL: String?
    var description: String?
    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        htmlURL <- map["html_url"]
        description <- map["description"]
    }
}

struct TJGithubState: Equatable {
    var page = 1
    var searchText = ""
    static func == (lhs: TJGithubState, rhs: TJGithubState) -> Bool {
        return (lhs.page == rhs.page &&
        lhs.searchText == rhs.searchText)
      }
}

class TJGithubViewModel {
    var searchList: [TJGithubModel] = []
    // output
   // let searchListDriver: Driver<[TJGithubModel]>
   // let searchText: Signal<String>

//
    init(input: (searchText: Driver<String>,
                 loadPageTrigger: Driver<Int>)) {
        
        
    }
    
}

class Service {
    static func requestWithText(_ text: String, page: Int) -> Observable<[TJGithubModel]> {
         return Observable<[TJGithubModel]>.create { (obj) -> Disposable in
            let url = "https://api.github.com/search/repositories"
            let param = ["q": text, "page": "\(page)"]
            var p = ""
            var n = false
            for (key, value) in param {
                if n {p = p + "&"}
               p = p + "\(key)=\(value)"
                n = true
            }
            let path = "\(url)?\(p)"
            print("url:\(path)")
             TJService.requestWithURL(url, param: param, method: .get) { (data, result) in
                print("result:\(result)")
                 if result == .success, let searchList = data?["items"] as? [[String: Any]], let model = Mapper<TJGithubModel>().mapArray(JSONObject: searchList) {
                    NSLog("on next")
                     obj.onNext(model)
                     obj.onCompleted()
                 } else {
                    NSLog("on error")
                     obj.onError(NSError(domain: "dddd", code: 1, userInfo: nil))
                 }
             }
             return Disposables.create()
         }
     }
}
