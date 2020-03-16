//
//  ListContract.swift
//  NewsList_MRT
//
//  Created by TaeinKim on 2020/03/16.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation

struct NewsFeed {
    var title: String?
    var link: String?
}

protocol ListPresenterProtocol {
    func requestRSSFeed()
}

protocol ListViewProtocol {
    func appendNewsFeeds(list: [NewsFeed])
}
