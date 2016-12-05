//
//  DriverShuttleViewController.swift
//  Shuttle2Home
//
//  Created by WENG on 16/11/11.
//  Copyright © 2016年 Wei Weng. All rights reserved.
//

import UIKit

class DriverShuttleViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var buses = ["6:00PM", "6:30PM", "7:00PM"];
    var destinations = ["Olive", "Pershing"]
    var pickerView : UIPickerView!
    var chooseTime : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(buses[0])
        setuppickerView()
        
        // Do any additional setup after loading the view.
    }
    
    func setuppickerView(){
        chooseTime = UILabel(frame: view.frame.offsetBy(dx:0, dy: 0))
        chooseTime.text = "Choose the bus you want to take"
        chooseTime.textAlignment = NSTextAlignment.Center
        chooseTime.font = UIFont(name:"Helvetica", size:20)
        pickerView = UIPickerView(frame: view.frame.offsetBy(dx:0, dy: 100))
        pickerView.delegate = self
        pickerView.dataSource = self
        view.addSubview(chooseTime)
        view.addSubview(pickerView)
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return buses.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return buses[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let detailedVC = DestinationsViewController(nibName: "DestinationsViewController", bundle: nil)
        //
        //        // detailedVC
        detailedVC.bus = buses[row]
        detailedVC.destinations = destinations
        
        //        detailedVC.image = theImageCache[indexPath.row]
        //
        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
