//
//  ListContract.swift
//  NewsList_MRT
//
//  Created by TaeinKim on 2020/03/16.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation
import UIKit

struct NewsFeed {
    var index: Int
    var title: String?
    var link: String?
    var image: UIImage?
    var desc: String?
    var keywords: [String]?
}

protocol ListPresenterProtocol {
    func requestRSSFeed()
}

protocol ListViewProtocol {
    func appendNewsFeeds(list: [NewsFeed])
}
