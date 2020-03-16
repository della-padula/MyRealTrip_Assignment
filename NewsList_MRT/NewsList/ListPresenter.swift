//
//  ListPresenter.swift
//  NewsList_MRT
//
//  Created by TaeinKim on 2020/03/16.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyXMLParser
import Kanna

class ListPresenter: ListPresenterProtocol {
    let url = "https://news.google.com/rss"
    private var view: ListViewProtocol!
    
    init(view: ListViewProtocol) {
        self.view = view
    }
    
    func requestRSSFeed() {
        AF.request(url).responseString(completionHandler: { response in
//            print(response)
            switch(response.result) {
            case .success(let result):
                let xml = try! XML.parse(result)
                var list = [NewsFeed]()
                for item in xml["rss", "channel", "item"] {
                    list.append(NewsFeed(title: item["title"].text ?? "", link: item["link"].text ?? ""))
                }
                self.view.appendNewsFeeds(list: list)
            case .failure(let error):
                print(error)
            }
        })
    }
}
