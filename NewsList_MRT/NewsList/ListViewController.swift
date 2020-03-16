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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newsListView.delegate = self
        self.newsListView.dataSource = self
    }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsListCell") as! NewsListCell
        
        cell.keywordList = ["Test0000001", "Test002", "Test3"]
        
        return cell
    }
    
    
}
