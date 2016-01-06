//
//  LocationViewController.swift
//  MyLocations
//
//  Created by yaoyingtao on 16/1/6.
//  Copyright © 2016年 yaoyingtao. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UITableViewController {
    var locations:[Location]!
    
    override func viewDidLoad() {
        locations = [Location]()
        let l1 = Location()
        l1.locationDescription = "London"
        locations.append(l1)
        
        let l2 = Location()
        l2.locationDescription = "Pairs"
        locations.append(l2)
        
        let l3 = Location()
        l3.locationDescription = "Tokyo"
        locations.append(l3)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell")
            let name = cell?.viewWithTag(100) as! UILabel
            let location = locations[indexPath.row] as Location
            name.text = location.locationDescription
            let address = cell?.viewWithTag(101) as! UILabel
            address.text = "you ok"
            return cell!
    }
}
