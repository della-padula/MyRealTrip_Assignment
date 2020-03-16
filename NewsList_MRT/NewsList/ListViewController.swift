//
//  ListViewController.swift
//  NewsList_MRT
//
//  Created by TaeinKim on 2020/03/16.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kanna

class ListViewController: UIViewController, ListViewProtocol {
    
    @IBOutlet weak var newsListView: UITableView!
    
    private var presenter: ListPresenterProtocol!
    private var newsFeedList = [NewsFeed]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = ListPresenter(view: self)
        
        self.newsListView.delegate = self
        self.newsListView.dataSource = self
        
        self.newsFeedList.removeAll()
        self.presenter.requestRSSFeed()
    }
    
    func appendNewsFeeds(list: [NewsFeed]) {
        self.newsFeedList.append(contentsOf: list)
        self.newsListView.reloadData()
    }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.newsFeedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsListCell") as! NewsListCell
        
        cell.item = self.newsFeedList[indexPath.row]
        cell.keywordList = ["Test0000001", "Test002", "Test3"]
        
        return cell
    }
    
    
}
