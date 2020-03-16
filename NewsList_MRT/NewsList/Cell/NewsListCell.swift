//
//  NewsListCell.swift
//  NewsList_MRT
//
//  Created by TaeinKim on 2020/03/16.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation
import UIKit

class KeywordCell: UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var keywordLabel: UILabel!
    
    var keyword: String? {
        didSet {
            self.bgView.layer.borderColor = UIColor.black.cgColor
            self.bgView.layer.borderWidth = 1
            self.bgView.layer.cornerRadius = self.bgView.bounds.height / 2
            self.keywordLabel.text = keyword
        }
    }
}

class NewsListCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var thumbnailView : UIImageView!
    @IBOutlet weak var titleLabel    : UILabel!
    @IBOutlet weak var summaryLabel  : UILabel!
    @IBOutlet weak var keywordListView: UICollectionView!
    
    var keywordList: [String]? {
        didSet {
            self.keywordListView.delegate   = self
            self.keywordListView.dataSource = self
            self.keywordListView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.keywordList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "keywordCell", for: indexPath) as! KeywordCell
        
        if let keyword = keywordList?[indexPath.row] {
            cell.keyword = keyword
        }
        
        return cell
    }
    
}
