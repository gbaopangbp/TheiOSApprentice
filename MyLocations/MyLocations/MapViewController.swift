//
//  MapViewController.swift
//  MyLocations
//
//  Created by cm on 16/1/7.
//  Copyright © 2016年 yaoyingtao. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showLocations(sender: UIBarButtonItem) {
        let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
        mapView.setRegion(region, animated: true)
    }
    
    
    @IBOutlet weak var showUser: UIBarButtonItem!

}

extension MapViewController:MKMapViewDelegate {
    
}
