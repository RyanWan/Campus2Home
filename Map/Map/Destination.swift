//
//  Destination.swift
//  Map
//
//  Created by Ryan Wan on 12/2/16.
//  Copyright © 2016 Ryan Wan. All rights reserved.
//

import UIKit

struct Destination {
    var lat:Double
    var lng:Double
    var address:String
    init(lat:Double,lng:Double,address:String){
        self.lat = lat;
        self.lng = lng;
        self.address = address;
    }
}
