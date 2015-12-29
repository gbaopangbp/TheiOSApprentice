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

class ListDetailControllrer: UITableViewController,UITextFieldDelegate,PickIconViewControllerProtocol {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate:ListDetailControllerProtocol?
    var list:CheckList?
    var iconName = "No Icon"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
        if let checkList = list {
            title = "EditCheckList"
            textField.text = checkList.name
            iconName = checkList.iconName
        }else{
            title = "AddCheckList"
        }
        iconImageView.image = UIImage(named: iconName)
    }

    @IBAction func done(sender: AnyObject) {
        if let checkList = list {
            checkList.name = textField.text!
            checkList.iconName = iconName
            delegate?.listDetailController(self, didFinishEditingList: checkList)
        }else{
            let checkList = CheckList(name: textField.text!)
            checkList.iconName = iconName
            delegate?.listDetailController(self, didFinishAddingList: checkList)
        }
    }
    @IBAction func cancel(sender: AnyObject) {
        delegate?.listDetailControllerCancel(self)
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return indexPath
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let old:NSString = textField.text!
        let newString:NSString = old.stringByReplacingCharactersInRange(range, withString: string)
        doneBarButton.enabled = (newString.length > 0)
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickIon" {
            let pickController = segue.destinationViewController as! PickIconViewController
            pickController.delegate = self
        }
    }
    
    func pickIconController(controller:PickIconViewController ,didPickIcon iconName:String){
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
        list?.iconName = iconName
        navigationController?.popToRootViewControllerAnimated(true)
    }

}
