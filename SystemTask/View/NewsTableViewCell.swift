//
//  PostsTableViewCell.swift
//  SystemTask
//
//  Created by Nikhil Balne on 30/10/20.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsStatusLabel: UILabel!
    @IBOutlet weak var newsContentLabel: UILabel!
    
    var newsItem: NewsPostModel!
    
    func setNewsDetails(newsItem: NewsPostModel) {
        
        newsTitleLabel.text = newsItem.title
        newsStatusLabel.text = newsItem.postStatus
        newsContentLabel.text = newsItem.content
        
        let data = try? Data(contentsOf: URL(string: newsItem.imageUrl)!)
        newsImageView.image = UIImage(data: data!)
    }
}
