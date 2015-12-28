//
//  CheckListItem.swift
//  CheckLists
//
//  Created by cm on 15/12/28.
//  Copyright © 2015年 cm. All rights reserved.
//

import UIKit

class CheckListItem: NSObject {
    var text = ""
    var checked = false
    
    func toggleChecked()->Void{
        checked = !checked
    }
}
