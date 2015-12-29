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
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey("text") as! String
        checked = aDecoder.decodeBoolForKey("checked")
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "text")
        aCoder.encodeBool(checked, forKey: "checked")
    }
    
    func toggleChecked()->Void{
        checked = !checked
    }
    
    
}
