//
//  UIImageView+DownloadImage.swift
//  StoreSearch
//
//  Created by cm on 16/1/22.
//  Copyright © 2016年 cm. All rights reserved.
//

import UIKit
extension UIImageView {
    func loadImagewithURL(url:NSURL) -> NSURLSessionDownloadTask {
        let session = NSURLSession.sharedSession()
        let downloadTask = session.downloadTaskWithURL(url, completionHandler: {
            [weak self] url,response, error in
            if error == nil && url != nil {
                if let data = NSData(contentsOfURL: url!) {
                    if let image = UIImage(data: data) {
                        dispatch_async(dispatch_get_main_queue(), {
                            if let strongSelf = self {
                                strongSelf.image = image
                            }
                        })
                    }
                }
            }
         })
        downloadTask.resume()
        return downloadTask
    }
}