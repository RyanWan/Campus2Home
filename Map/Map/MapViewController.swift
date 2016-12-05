//
//  ViewController.swift
//  Map
//
//  Created by Ryan Wan on 11/19/16.
//  Copyright © 2016 Ryan Wan. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {
    
    var address = "605+Leland+Ave,MO"
    var apiKey = "AIzaSyA-zNnojD_2V81XAKp-AShKGNb32bRwtfI"
    var destinations:[Destination] = []
    var markers:[GMSMarker] = []
    var flag:Bool = false
    
    
    //api key for geocoding:AIzaSyA-zNnojD_2V81XAKp-AShKGNb32bRwtfI

    // You don't need to modify the default init(nibName:bundle:) method.
    var nextButton : UIButton = UIButton(frame: CGRect.zero);
    
    override func loadView() {

        // Create a GMSCameraPosition
        let camera = GMSCameraPosition.cameraWithLatitude(38.648342, longitude: -90.311463, zoom: 16.0)
        let mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
        mapView.myLocationEnabled = true
        //creat the plan route button
        let button = UIButton(frame: CGRectMake(160, 600, 80, 40))
        button.backgroundColor = UIColor.lightGrayColor()
        button.setTitle("Next", forState: .Normal)
        nextButton = button
        button.addTarget(self, action: "nextButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        mapView.addSubview(button)
        view = mapView
        
        
        // Creates markers
        for index in 0...destinations.count-2 {
            let dest = destinations[index]
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: dest.x, longitude:dest.y)
            marker.title = "\(index)"
            marker.map = mapView
            markers.append(marker)
        
        }
        mapView.selectedMarker = markers[1]
        
        //draw route
        if (flag){
            let path = GMSMutablePath()
            for index in 0...destinations.count-1 {
                let dest = destinations[index]
                path.addCoordinate(CLLocationCoordinate2D(latitude: dest.x, longitude: dest.y))
            }
            let polyline = GMSPolyline(path: path)
            polyline.map = mapView
        }

        
        

    }
    
    func nextButtonClicked(sender:UIButton!) {
        destinations.removeAtIndex(1)
        markers.removeAtIndex(1)
        for index in 1...markers.count-1{
            markers[index].title = "\(Int(markers[index].title!)!-1)"
        }
        
        print("Button Clicked")
    }
    

    private func getJSON(url: String) -> JSON {
        
        if let nsurl = NSURL(string: url){
            if let data = NSData(contentsOfURL: nsurl) {
                let json = JSON(data: data)
                return json
            } else {
                return nil
            }
        } else {
            return nil
        }
        
    }

}

