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
import Kingfisher
import Kanna

class ListPresenter: ListPresenterProtocol {
    let url = "https://news.google.com/rss"
    
    private var keyPairList = [KeyPair]()
    private var imageList = [UIImage?]()
    private var descList = [String]()
    private var view: ListViewProtocol!
    
    private var size: Int = 0
    private let fetchCount: Int = 10
    private var list = [NewsFeed]()
    private var sliceList = [NewsFeed]()
    
    let serialQueue = DispatchQueue(label: "swiftlee.serial.queue")
    
    init(view: ListViewProtocol) {
        self.view = view
    }
    
    func requestRSSFeed() {
        self.list.removeAll()
        AF.request(url).responseString(completionHandler: { response in
            switch(response.result) {
            case .success(let result):
                let xml = try! XML.parse(result)
                for (index, item) in xml["rss", "channel", "item"].enumerated() {
                    let feed = NewsFeed(index: index, title: item["title"].text ?? "", link: item["link"].text ?? "")
                    self.list.append(feed)
                }
                self.view.appendNewsFeeds(list: self.list)
//                self.fetchNewsFeedPage(page: 0)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func fetchNewsFeedPage(page: Int) {
        let startIndex = page * fetchCount
        let endIndex = startIndex + fetchCount
        self.sliceList.removeAll()
        self.sliceList = Array(self.list[startIndex..<endIndex])
        self.size = 0
        for (index, sliceItem) in self.sliceList.enumerated() {
            self.parseImageDescription(index: startIndex + index, item: sliceItem)
        }
    }
    
    func parseImageDescription(index: Int, item: NewsFeed) {
        if let url = item.link {
            AF.request(url).responseString(encoding: .utf8) { response in
                self.size += 1
                switch(response.result) {
                    case .success(_):
//                        self.size += 1
                        if let data = response.value {
                            do {
                                let doc = try HTML(html: data, encoding: .utf8)
                                var imageURL: String = ""
                                var descriptionText: String = ""
                                
                                self.keyPairList.removeAll()
                                
                                for product in doc.css("meta[property='og:image']") {
                                    imageURL = product["content"] ?? ""
                                }
                                
                                for product in doc.css("meta[property='og:description']") {
                                    descriptionText = product["content"] ?? ""
                                    self.list[index].desc = descriptionText
                                }
                                
                                let keywordList = descriptionText.split(separator: " ")

                                for keyword in keywordList {
                                    self.addKeywordWithCount(keyword: String(keyword))
                                }
                                
                                self.keyPairList.sort { $0.count > $1.count }
                                let iSize = self.keyPairList.count > 2 ? 3 : (self.keyPairList.count)
                                let slice = self.keyPairList[0..<iSize]
                                
                                // KEYWORD
                                self.list[index].keywords = Array(slice.map { $0.keyword })
                                
                                if let url = URL(string: imageURL) {
                                    let imageData = try Data(contentsOf: url)
                                    // THUMBNAIL
                                    self.list[index].image = UIImage(data: imageData)
                                }
                                
//                                self.size += 1
                                print("SIZE / LIST_COUNT : \(self.size) / \(self.list.count)")
                                if self.fetchCount == self.size {
                                    self.view.appendNewsFeeds(list: self.sliceList)
                                }
                            } catch let error {
                                print("Error : \(error)")
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
        }
    }
    
    private func addKeywordWithCount(keyword: String) {
        var isExist = false
        if keyword.count > 2 {
            for (index, item) in self.keyPairList.enumerated() {
                if item.keyword == keyword {
                    isExist = true
                    self.keyPairList[index].count = item.count + 1
                    break
                }
            }
            
            if !isExist {
                self.keyPairList.append(KeyPair(keyword: keyword, count: 1))
            }
        }
    }
    
    private func sortKeywordWithCount() {
        self.keyPairList.sort { $0.count > $1.count }
    }
}

