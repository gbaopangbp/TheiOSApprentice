//
//  Location.swift
//  MyLocations
//
//  Created by yaoyingtao on 16/1/6.
//  Copyright © 2016年 yaoyingtao. All rights reserved.
//

import UIKit
import CoreLocation

class Location: NSObject {
     var latitude: Double
     var longitude: Double
     var date: NSDate
     var locationDescription: String?
     var category: String?
     var placemark: CLPlacemark?
    
    override init(){
        latitude = 0.0
        longitude = 0.0
        date = NSDate()
        locationDescription = ""
        
    }
}
