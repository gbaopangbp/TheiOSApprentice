//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by yaoyingtao on 16/1/1.
//  Copyright © 2016年 yaoyingtao. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class LocationDetailsViewController: UITableViewController {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel:UILabel!
    @IBOutlet weak var latitueLabel:UILabel!
    @IBOutlet weak var longitudeLabel:UILabel!
    @IBOutlet weak var addressLabel:UILabel!
    @IBOutlet weak var datexLabel:UILabel!
    
    var placemark:CLPlacemark?
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var descriptionText = ""
    var categoryName = "No Category"
    var managedObjectContex:NSManagedObjectContext!

    
    private let dateFormater:NSDateFormatter = {
        let dateFormater = NSDateFormatter()
        dateFormater.timeStyle = .ShortStyle
        dateFormater.dateStyle = .ShortStyle
        return dateFormater
    }()

    

    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTextView.text = descriptionText
        categoryLabel.text = categoryName
        
        latitueLabel.text = String(format: "%.8f", coordinate.latitude)
        longitudeLabel.text = String(format:"%.8f",coordinate.longitude)
        
        if let placemark = placemark {
            addressLabel.text = stringFromPlacemark(placemark)
        }else {
            addressLabel.text = "No Address No Address No Address No Address No Address No Address"
        }
        
        datexLabel.text = strigFromDate(NSDate())
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard:"))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        descriptionTextView.frame.size.width = view.frame.size.width - 20
    }
    
    func stringFromPlacemark(placemark:CLPlacemark)->String{
        return "\(placemark.subThoroughfare) \(placemark.thoroughfare), " + "\(placemark.locality), " +
            "\(placemark.administrativeArea) \(placemark.postalCode)," + "\(placemark.country)"
    }
    
    func strigFromDate(date:NSDate)->String{
        return dateFormater.stringFromDate(date)
    }


    // MARK: - tableView datasource
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 88
        } else if indexPath.section == 2 && indexPath.row == 2 {
            addressLabel.frame.size = CGSizeMake(view.frame.size.width - 115, 10000)
            addressLabel.sizeToFit()
            addressLabel.frame.origin.x = view.frame.size.width - addressLabel.frame.size.width - 15
            return addressLabel.frame.size.height + 20
        } else {
            return 44
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 0 || indexPath.section == 1 {
            return indexPath
    } else {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            descriptionTextView.becomeFirstResponder()
        }
    }
    
    // MARK: - event response
    @IBAction func done(){
        let hudView = HudView.hudInView(navigationController!.view, animated: true)
        hudView.text = "Tagged"
        
        afterDelay(0.6, closure: {
            self.dismissViewControllerAnimated(true, completion: nil)
            })
    }
    
    @IBAction func cancel(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func hideKeyboard(tap:UITapGestureRecognizer) {
        let point = tap.locationInView(view)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        if indexPath != nil && indexPath?.row == 0 && indexPath?.section == 0 {
            return
        }
        
//        descriptionTextView.resignFirstResponder()
        view.endEditing(true)
    }

    //MARK: - prepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickCategory" {
            let controller = segue.destinationViewController as! CategoryPickerViewController
            controller.selectCategoryName = categoryName
        }
    }
    
    //MARK: - category exit
    @IBAction func categoryPickerDidSelectName(segu:UIStoryboardSegue){
        if segu.identifier == "DidCategory" {
            let controller = segu.sourceViewController as! CategoryPickerViewController
            categoryName = controller.selectCategoryName
            categoryLabel.text = categoryName
        }

    }

}

extension LocationDetailsViewController:UITextViewDelegate {
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        descriptionText = (descriptionTextView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
    return true
    }
}
