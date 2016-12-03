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
    
    //api key for geocoding:AIzaSyA-zNnojD_2V81XAKp-AShKGNb32bRwtfI

    // You don't need to modify the default init(nibName:bundle:) method.
    
    override func loadView() {

        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.cameraWithLatitude(38.648342, longitude: -90.311463, zoom: 16.0)
        let mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
//        mapView.frame = CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.height * 0.7);
        mapView.myLocationEnabled = true
        let button = UIButton(frame: CGRectMake(200, 600, 50, 20))
        button.backgroundColor = UIColor.blackColor()
        button.titleLabel?.textColor = UIColor.whiteColor()
        button.titleLabel!.text = "Next"
        
        mapView.addSubview(button)
        view = mapView
        
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 38.648342, longitude:-90.311463)
        marker.title = "1"
        //marker.tracksInfoWindowChanges
        marker.map = mapView
        mapView.selectedMarker = marker
        
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2D(latitude: 38.647698,longitude:-90.309694)
        marker2.title = "2"
        marker2.map = mapView
        mapView.selectedMarker = marker2
        
        let path = GMSMutablePath()
        path.addCoordinate(CLLocationCoordinate2D(latitude: 38.648342, longitude: -90.311463))
        path.addCoordinate(CLLocationCoordinate2D(latitude:38.647698, longitude: -90.309694))
        let polyline = GMSPolyline(path: path)
        polyline.map = mapView
        
        
        loadData(self.address)
        
//        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
//        self.view.addSubview(navBar);
//        let navItem = UINavigationItem(title: "SomeTitle");
//        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: nil, action: "selector");
//        navItem.rightBarButtonItem = doneItem;
//        navBar.setItems([navItem], animated: false);
    }
    
    
    func loadData(searchText:String){
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED,0)){
            
            self.fetchData(self.address)
            
            dispatch_async(dispatch_get_main_queue()){
                
                print("Done")
            }
        }
    }
    
    func fetchData(searchText:String){
        let json = getJSON("https://maps.googleapis.com/maps/api/geocode/json?address=\(searchText)&key=\(self.apiKey)")
        let jsonContent = json["results"].arrayValue
        
        if (jsonContent.count != 0){
            let result = jsonContent[0]
            let formatted_address = result["formatted_address"].stringValue
            let lat = result["geometry"]["location"]["lat"]
            let lng = result["geometry"]["location"]["lng"]
            print(formatted_address)
            print(lat)
            print(lng)
        }else {
            print("no result found")
        }
        
//        let jsonContent = json["Search"].arrayValue
//        for result in jsonContent {
//            let title = result["Title"].stringValue
//            let year = result["Year"].stringValue
//            let url = result["Poster"].stringValue
//            let id = result["imdbID"].stringValue
//            let type = result["Type"].stringValue
//            theData.append(Movie(title:title,url:url,id:id, year:year,type:type))
//            if (type == "movie"){
//                movieData.append(Movie(title:title,url:url,id:id, year:year,type:type))
//            }
//        }
        
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

