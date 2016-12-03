//
//  SubmitViewController.swift
//  Shuttle2Home
//
//  Created by WENG on 16/11/9.
//  Copyright © 2016年 Wei Weng. All rights reserved.
//

import UIKit

class SubmitViewController: UIViewController {
    
    var bus: String!

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = bus
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitAddress(sender: AnyObject) {
        let def = NSUserDefaults.standardUserDefaults()
        
        var array1: [NSString] = [NSString]()
        array1.append("value 1")
        array1.append("value 2")
        
        //save
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(array1, forKey: bus)
        defaults.synchronize()
        
        //read
        if let testArray : AnyObject? = defaults.objectForKey(bus) {
            var readArray : [NSString] = testArray! as! [NSString]
            print(readArray)
        }
        
        let detailedVC = AfterSubmitViewController(nibName: "AfterSubmitViewController", bundle: nil)
        detailedVC.bus = self.bus
        navigationController?.pushViewController(detailedVC, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
