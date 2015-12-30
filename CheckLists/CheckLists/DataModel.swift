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
    var indexOfCheckList:Int{
        get{
            return NSUserDefaults.standardUserDefaults().integerForKey("CheckListIndex")
        }
        set{
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "CheckListIndex")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    init(){
        registerDefault()
        loadCheckLists()
        handleFirstTime()
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
                sortCheckLists()
            }
        }
    }
    
    func registerDefault(){
        let defaultIndex = ["CheckListIndex":-1,"FirstTime":true,"NextItemIndex":0]
        NSUserDefaults.standardUserDefaults().registerDefaults(defaultIndex)
    }
    
    func handleFirstTime(){
        let firstTime = NSUserDefaults.standardUserDefaults().boolForKey("FirstTime")
        if firstTime {
            let list = CheckList(name: "List")
            lists.append(list)
            indexOfCheckList = 0
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "FirstTime")
        }
    }
    
    func sortCheckLists(){
        lists.sortInPlace({list1,list2 in list1.name.localizedStandardCompare(list2.name) == NSComparisonResult.OrderedAscending})
    }
    
    class func nextItemIndex()->Int{
        var index = NSUserDefaults.standardUserDefaults().integerForKey("NextItemIndex")
        index += 1
        NSUserDefaults.standardUserDefaults().setInteger(index, forKey: "NextItemIndex")
        NSUserDefaults.standardUserDefaults().synchronize()
        return index
    }
    
}