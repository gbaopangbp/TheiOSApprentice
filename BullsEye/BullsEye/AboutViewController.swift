//
//  AboutViewController.swift
//  BullsEye
//
//  Created by cm on 15/12/22.
//  Copyright © 2015年 cm. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let html = NSBundle.mainBundle().pathForResource("BullsEye", ofType: "html") {
            let htmlData = NSData(contentsOfFile: html)
            let htmlUrl = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath)
            webView.loadData(htmlData!, MIMEType: "text/html", textEncodingName: "UTF-8", baseURL: htmlUrl)
            
        }
        
        
    }

    
    @IBAction func close(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
