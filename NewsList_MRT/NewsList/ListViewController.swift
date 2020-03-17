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
    
    private var refreshControl = UIRefreshControl()
    
    private var presenter: ListPresenterProtocol!
    private var newsFeedList = [NewsFeed]()
    private var isUpdateComplete: Bool = false
    private var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = ListPresenter(view: self)
        
        self.newsListView.delegate = self
        self.newsListView.dataSource = self
        
        self.newsListView.separatorInset = .zero
        self.newsListView.tableFooterView = UIView()
        
        if #available(iOS 10.0, *) {
            self.newsListView.refreshControl = refreshControl
        } else { self.newsListView.addSubview(refreshControl) }
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        self.newsFeedList.removeAll()
        self.presenter.requestRSSFeed()
    }
    
    @objc func refresh() {
        self.page = 0
        self.isUpdateComplete = false
        self.newsFeedList.removeAll()
        self.presenter.requestRSSFeed()
    }
    
    func appendNewsFeeds(list: [NewsFeed]) {
        self.newsFeedList.append(contentsOf: list)
        self.refreshControl.endRefreshing()
        self.isUpdateComplete = true
        self.newsListView.reloadData()
    }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.newsFeedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsListCell") as! NewsListCell
        print(indexPath.row)
        
        if self.isUpdateComplete {
            cell.item = self.newsFeedList[indexPath.row]
        }
        
        return cell
    }
    
    
}
