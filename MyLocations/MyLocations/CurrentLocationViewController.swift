//
//  FirstViewController.swift
//  MyLocations
//
//  Created by yaoyingtao on 15/12/30.
//  Copyright © 2015年 yaoyingtao. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var messageLabel:UILabel!
    @IBOutlet weak var latitudeLabel:UILabel!
    @IBOutlet weak var longitudeLabel:UILabel!
    @IBOutlet weak var adressLabel:UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    
    let locationManger = CLLocationManager()
    var location:CLLocation?
    var errorLocation:NSError?
    var updatingLocation = false
    
    var requestingGeo = false
    var errorGeo:NSError?
    let geocoder = CLGeocoder()
    var placemark:CLPlacemark?
    
    var timer:NSTimer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
        configeGetButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func getLocation(sender: UIButton) {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .NotDetermined {
            locationManger.requestWhenInUseAuthorization()
        }
        
        if authStatus == .Restricted || authStatus == .Denied {
            showLocationServiceDeniedAlert()
            return
        }
        
        if updatingLocation {
            stopLocationManger()
        }else{
            location = nil
            errorLocation = nil
            placemark = nil
            requestingGeo = false
            startLocationManger()
        }
        
        updateLabels()
        configeGetButton()

    }
    
    func startLocationManger() {
        if CLLocationManager.locationServicesEnabled() {
            updatingLocation = true
            locationManger.delegate = self
            locationManger.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManger.startUpdatingLocation()
            timer = NSTimer(timeInterval: 60, target: self, selector: Selector("didTimeOut"), userInfo: nil, repeats: false)
        }
    }
    
    func stopLocationManger() {
        if updatingLocation {
            updatingLocation = false
            locationManger.stopUpdatingLocation()
            locationManger.delegate = nil
            
            if let timer = timer {
                timer.invalidate()
            }
        }
    }
    
    func showLocationServiceDeniedAlert(){
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings.", preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func updateLabels() {
        if let location = location {
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            messageLabel.text = ""
            tagButton.hidden = false
            
            if let placemark = placemark {
                adressLabel.text = stringFromPlacemark(placemark)
            } else if requestingGeo {
                adressLabel.text = "Searching for Address..."
            } else if errorGeo != nil {
                adressLabel.text = "Error Finding Address"
            } else {
                adressLabel.text = "No Address Found"
            }
        }else{
            var message = ""
            if let error = errorLocation{
                if error.domain == kCLErrorDomain && error.code == CLError.Denied.rawValue{
                    message = "Location Services Disabled"
                }else {
                    message = "Error Getting Location"
                }
            } else if !CLLocationManager.locationServicesEnabled(){
                message = "Location Services Disabled"
            } else if updatingLocation {
                message = "Searching..."
            } else {
                message = "Tap 'Get My Location' to Start"
            }
            
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            messageLabel.text = message
            tagButton.hidden = true
        }
    }
    
    func configeGetButton() {
        if updatingLocation {
            getButton.setTitle("Stop", forState: .Normal)
        } else {
            getButton.setTitle("Get Location", forState: .Normal)
        }
    }
    
    func stringFromPlacemark(placemark:CLPlacemark)->String{
        return
            "\(placemark.subThoroughfare) \(placemark.thoroughfare)\n" + "\(placemark.locality) \(placemark.administrativeArea) " + "\(placemark.postalCode)"
    }
    
    func didTimeOut(){
        if location == nil {
            stopLocationManger()
            errorLocation = NSError(domain: "MyLocationErrorDomain", code: 1, userInfo: nil)
            updateLabels()
            configeGetButton()
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("fail")
        
        if error.code == CLError.LocationUnknown.rawValue {
            return
        }
        errorLocation = error
        stopLocationManger()
        updateLabels()
        configeGetButton()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(" success -- \(locations.last)")
        let newLocation = locations.last
        //缓存的位置丢弃
        if newLocation?.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        
        //无效的位置
        if newLocation?.horizontalAccuracy < 0 {
            return
        }
        
        var distance = CLLocationDistance(DBL_MAX)
        if let location = location {
            distance = (newLocation?.distanceFromLocation(location))!
        }
        
        if location == nil || location!.horizontalAccuracy > newLocation?.horizontalAccuracy {
            location = newLocation
            errorLocation = nil
            updateLabels()
            
            if newLocation?.horizontalAccuracy < locationManger.desiredAccuracy {
                stopLocationManger()
                configeGetButton()
                if distance > 0 {
                    requestingGeo = false
                }
            }
            
            if !requestingGeo {
                requestingGeo = true
                geocoder.reverseGeocodeLocation(location!, completionHandler: {plackmarks, error in
                    self.errorGeo = error
                    if error == nil && !plackmarks!.isEmpty {
                        self.placemark = plackmarks?.last
                    }
                    self.requestingGeo = false
                    self.updateLabels()
                    })
            }
        }else {
            if distance < 1 {
                let timestamp = newLocation?.timestamp.timeIntervalSinceDate((location?.timestamp)!)
                if timestamp > 10 {
                    stopLocationManger()
                    updateLabels()
                    configeGetButton()
                }
            }

        }
    }
    
    // MARK: - prepareForSegue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TagLocation" {
            let naviController = segue.destinationViewController as! UINavigationController
            let tagController = naviController.topViewController as! LocationDetailsViewController
            tagController.placemark = placemark
            tagController.coordinate = location!.coordinate
        }
    }

    
}

