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

class ViewController: UIViewController {
    
    var address = "605+Leland+Ave,MO"
    var apiKey = "AIzaSyA-zNnojD_2V81XAKp-AShKGNb32bRwtfI"
    
    //api key for geocoding:AIzaSyA-zNnojD_2V81XAKp-AShKGNb32bRwtfI

    // You don't need to modify the default init(nibName:bundle:) method.
    
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.cameraWithLatitude(-33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
        mapView.myLocationEnabled = true
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        loadData(self.address)
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

