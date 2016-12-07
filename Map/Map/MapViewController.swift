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
    var Path:GMSMutablePath!
    var Line: GMSPolyline!
    var Map: GMSMapView!
    //api key for geocoding:AIzaSyA-zNnojD_2V81XAKp-AShKGNb32bRwtfI

    // You don't need to modify the default init(nibName:bundle:) method.
    var nextButton : UIButton = UIButton(frame: CGRect.zero);
    
    override func loadView() {
        // Create a GMSCameraPosition
        let camera = GMSCameraPosition.cameraWithLatitude(38.648342, longitude: -90.311463, zoom: 16.0)
        Map = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
        
        Map.myLocationEnabled = true
        //creat the plan route button
        let button = UIButton(frame: CGRectMake(160, 600, 80, 40))
        button.backgroundColor = UIColor.lightGrayColor()
        button.setTitle("Next", forState: .Normal)
        nextButton = button
        button.addTarget(self, action: "nextButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        Map.addSubview(button)
        view = Map
        if (!flag){
             nextButton.hidden = true
        }
    
        if (destinations.count <= 2){
            print(flag)
            return
        }
        
        // Creates markers
        for index in 0...destinations.count-1 {
            let dest = destinations[index]
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: dest.x, longitude:dest.y)
            
            marker.map = Map
            markers.append(marker)
        
        }
        markers[0].title = "Start"
        if (flag){
            Map.selectedMarker = markers[1]
        }
        
        //draw route
        
        let path = GMSMutablePath()
        for index in 0...destinations.count-1 {
            let dest = destinations[index]
            path.addCoordinate(CLLocationCoordinate2D(latitude: dest.x, longitude: dest.y))
        }
        Path = path
        Line = GMSPolyline(path: path)
        Line.map = Map
       

        
        

    }
    func removeLine(){
        Path.removeCoordinateAtIndex(0)
        Line.map = nil
        Line = GMSPolyline(path: Path)
        Line.map = Map
    }
    
    func fitMarkers(){
        var bounds = GMSCoordinateBounds()
        for marker in markers{
            bounds = bounds.includingCoordinate(marker.position)
        }
        Map.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds))
    }
    
    func nextButtonClicked(sender:UIButton!) {
        if (markers.count > 0){
            destinations.removeAtIndex(0)
            markers[0].map = nil
            markers.removeAtIndex(0)
            fitMarkers()
            if (markers.count > 0){
                Map.camera = GMSCameraPosition.cameraWithLatitude(destinations[0].x, longitude: destinations[0].y, zoom: 16.0)
                markers[0].title = "Next"
                Map.selectedMarker = markers[0]
                removeLine()
            }
        }
        print("Button Clicked")
                if (markers.count == 0){
            let alert = UIAlertView()
            alert.title = "Note"
            alert.message = "Trip Finished"
            alert.addButtonWithTitle("Cancel")
            alert.show()
        }
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

