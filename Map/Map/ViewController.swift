//
//  ViewController.swift
//  Shuttle2Home
//
//  Created by WENG on 16/11/9.
//  Copyright © 2016年 Wei Weng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var driverButton: UIButton!
    @IBOutlet weak var passengerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor.lightGrayColor()
        let buttonColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
        driverButton.backgroundColor = buttonColor
        passengerButton.backgroundColor = buttonColor
        driverButton.setTitleColor(UIColor.lightTextColor(), forState: .Normal)
        passengerButton.setTitleColor(UIColor.lightTextColor(), forState: .Normal)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

