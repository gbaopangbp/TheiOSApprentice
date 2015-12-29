//
//  CheckList.swift
//  CheckLists
//
//  Created by cm on 15/12/29.
//  Copyright © 2015年 cm. All rights reserved.
//

import UIKit

class CheckList: NSObject,NSCoding {
    var name = ""
    var items = [CheckListItem]()
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("Name") as! String
        items = aDecoder.decodeObjectForKey("Items") as! [CheckListItem]
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "Name")
        aCoder.encodeObject(items, forKey: "Items")
    }
    
    init(name:String) {
        self.name = name
        super.init()
    }
    
}
