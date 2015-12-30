//
//  CheckListItem.swift
//  CheckLists
//
//  Created by cm on 15/12/28.
//  Copyright © 2015年 cm. All rights reserved.
//

import UIKit

class CheckListItem: NSObject,NSCoding {
    var text = ""
    var checked = false
    var shouleRemid = false
    var remindDate = NSDate()
    var itemIndex:Int
    
    override init() {
        itemIndex = DataModel.nextItemIndex()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey("text") as! String
        checked = aDecoder.decodeBoolForKey("checked")
        shouleRemid = aDecoder.decodeBoolForKey("ShouldRemind")
        remindDate = aDecoder.decodeObjectForKey("RemindDate") as! NSDate
        itemIndex = aDecoder.decodeIntegerForKey("ItemIndex")
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "text")
        aCoder.encodeBool(checked, forKey: "checked")
        aCoder.encodeBool(shouleRemid, forKey: "ShouldRemind")
        aCoder.encodeObject(remindDate, forKey: "RemindDate")
        aCoder.encodeInteger(itemIndex, forKey: "ItemIndex")    }
    
    func toggleChecked()->Void{
        checked = !checked
    }
    
    
}
