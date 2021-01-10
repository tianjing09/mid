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
    var isDownLoading = false
    var searchLists: [TJGithubModel] = []
    static func == (lhs: TJGithubState, rhs: TJGithubState) -> Bool {
        return (lhs.page == rhs.page &&
        lhs.searchText == rhs.searchText)
      }
}

class TJGithubViewModel {
    var state = TJGithubState()
    var isFirst = true
    // output
    var searchListDriver: Observable<[TJGithubModel]> = Observable.of([])
   
    init(input: (searchText: Observable<String>,
                 loadPageTrigger: Observable<Int>)) {
        let searchSignal = input.searchText
            .throttle(0.4, scheduler: MainScheduler.instance)
            .map { [weak self](text) -> String in
            print("search signal")
            self!.state.searchText = text
            self!.state.page = 1
            self!.state.isDownLoading = true
            self!.state.searchLists = []
            return text
        }
        
        let triggerObservable = input.loadPageTrigger
            .filter {page -> Bool in
            if page == 1209 {
                return true
            }
            return !self.state.isDownLoading
            }
            .map { (page) -> Int in
            print("trigger signal")
            self.state.isDownLoading = true
            if page != 1209 {
              self.state.page = self.state.page + 1
            }
            return self.state.page
        }
        
        searchListDriver = Observable.combineLatest(searchSignal,triggerObservable) { (text, page) -> TJGithubState in
            return TJGithubState(page: page, searchText: text)
        }
        .filter { (t) -> Bool in
            print("filter:\(t)")
            if t.searchText.count == 0 {
              self.state.isDownLoading = false
            }
            return t.searchText.count > 0
        }
        .distinctUntilChanged()
        .flatMapLatest { (state) -> Observable<[TJGithubModel]> in
           return Service.requestWithText(state.searchText, page: state.page)
        }
        .map { (model) -> [TJGithubModel] in
            print(model.count)
            self.state.searchLists.append(contentsOf: model)
            print(self.state.searchLists.count)
            self.state.isDownLoading = false
            return self.state.searchLists
        }
        
    }
}

class Service {
    static func requestWithText(_ text: String, page: Int) -> Observable<[TJGithubModel]> {
         return Observable<[TJGithubModel]>.create { (obj) -> Disposable in
            let url = "https://api.github.com/search/repositories"
            let param = ["q": text, "page": "\(page)"]
            Service.printWithURL(url, param: param)
             TJService.requestWithURL(url, param: param, method: .get) { (data, result) in
                print("result:\(result)")
                 if result == .success, let searchList = data?["items"] as? [[String: Any]], let model = Mapper<TJGithubModel>().mapArray(JSONObject: searchList) {
                    NSLog("on next")
                     obj.onNext(model)
                     obj.onCompleted()
                 } else {
                    print("on error")
                     obj.onError(NSError(domain: "dddd", code: 1, userInfo: nil))
                 }
             }
             return Disposables.create()
         }
     }
    
    static func printWithURL(_ url: String, param: Dictionary<String, Any>) {
        var p = ""
        var isNotFirst = false
        for (key, value) in param {
            if isNotFirst {p = p + "&"}
            p = p + "\(key)=\(value)"
            isNotFirst = true
        }
        let path = "\(url)?\(p)"
        print("url:\(path)")
    }
}
