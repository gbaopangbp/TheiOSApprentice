//
//  DataModel.swift
//  CheckLists
//
//  Created by cm on 15/12/29.
//  Copyright © 2015年 cm. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [CheckList]()
    
    init(){
        loadCheckLists()
    }
    
    func documentsDirectory()->String{
        let dir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return dir[0]
    }
    
    func dataFilePath()->String{
        return documentsDirectory().stringByAppendingString("/CheckList.plist")
    }
    
    func saveCheckLists(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(lists, forKey: "CheckLists")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadCheckLists(){
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                lists = unarchiver.decodeObjectForKey("CheckLists") as! [CheckList]
                unarchiver.finishDecoding()
            }
        }
    }
    
}