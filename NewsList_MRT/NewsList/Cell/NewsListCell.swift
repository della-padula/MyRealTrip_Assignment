//
//  NewsListCell.swift
//  NewsList_MRT
//
//  Created by TaeinKim on 2020/03/16.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kanna
import Kingfisher

struct KeyPair {
    var keyword: String
    var count: Int
}

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
    
    var keyPairList = [KeyPair]()
    
    var item: NewsFeed? {
        didSet {
            self.titleLabel.text = item?.title ?? ""
            self.parseImageDescription()
        }
    }
    
    var keywordList: [String]? {
        didSet {
            self.keywordListView.delegate   = self
            self.keywordListView.dataSource = self
            self.keywordListView.reloadData()
        }
    }
    
    func parseImageDescription() {
        if let url = item?.link {
            AF.request(url).responseString(encoding: .utf8) { response in
                switch(response.result) {
                    case .success(_):
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
                                }
                                
                                let keywordList = descriptionText.split(separator: " ")

                                for keyword in keywordList {
                                    self.addKeywordWithCount(keyword: String(keyword))
                                }
                                
                                // Keyword Iteration
                                self.keyPairList.sort { $0.count > $1.count }
                                print("-----")
                                for keypair in self.keyPairList {
                                    print("keyword : \(keypair.keyword) / count : \(keypair.count)")
                                }
                                
                                
                                if let url = URL(string: imageURL) {
                                    self.thumbnailView.kf.setImage(with: url)
                                }
                                self.summaryLabel.text = descriptionText
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
    
    func addKeywordWithCount(keyword: String) {
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
    
    func sortKeywordWithCount() {
        self.keyPairList.sort { $0.count > $1.count }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text     = nil
        self.summaryLabel.text   = nil
        self.thumbnailView.image = nil
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
