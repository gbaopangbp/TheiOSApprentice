//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by cm on 16/1/14.
//  Copyright © 2016年 cm. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artImageView: UIImageView!
    var downloadTask:NSURLSessionDownloadTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let selectView = UIView(frame: CGRect.zero)
        selectView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
        selectedBackgroundView = selectView
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
        nameLabel.text = nil
        artistNameLabel.text = nil
        artImageView.image = nil

    }
    
    func configureForSearchResult(result:SearchResult){
        self.nameLabel.text = result.name
        self.artistNameLabel.text = result.artistName
        if let url = NSURL(string: result.artworkURL60) {
            self.artImageView.loadImagewithURL(url)
        }
    }
    
}
