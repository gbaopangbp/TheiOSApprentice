//
//  ListDetailControllrer.swift
//  CheckLists
//
//  Created by cm on 15/12/29.
//  Copyright © 2015年 cm. All rights reserved.
//

import UIKit

protocol ListDetailControllerProtocol:class{
    func listDetailControllerCancel(controller:ListDetailControllrer)
    func listDetailController(controller:ListDetailControllrer, didFinishEditingList list:CheckList)
    func listDetailController(controller:ListDetailControllrer, didFinishAddingList list:CheckList)

}

class ListDetailControllrer: UITableViewController,UITextFieldDelegate {
    
    weak var delegate:ListDetailControllerProtocol?
    var list:CheckList?
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
        if let checkList = list {
            title = "EditCheckList"
            textField.text = checkList.name
        }else{
            title = "AddCheckList"
        }
    }

    @IBAction func done(sender: AnyObject) {
        if let checkList = list {
            checkList.name = textField.text!
            delegate?.listDetailController(self, didFinishEditingList: checkList)
        }else{
            let checkList = CheckList(name: textField.text!)
            delegate?.listDetailController(self, didFinishAddingList: checkList)
        }
    }
    @IBAction func cancel(sender: AnyObject) {
        delegate?.listDetailControllerCancel(self)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let old:NSString = textField.text!
        let newString:NSString = old.stringByReplacingCharactersInRange(range, withString: string)
        doneBarButton.enabled = (newString.length > 0)
        return true
    }
}
