//
//  ShuttleViewController.swift
//  Shuttle2Home
//
//  Created by WENG on 16/11/9.
//  Copyright © 2016年 Wei Weng. All rights reserved.
//

import UIKit

class ShuttleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var buses = ["6:00PM", "6:30PM", "7:00PM"];
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(buses[0])
        setupTableView()

        // Do any additional setup after loading the view.
    }
    
    func setupTableView() {
        
        tableView = UITableView(frame: view.frame.offsetBy(dx:0, dy: 0))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return buses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = buses[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("Time to show \(indexPath.row)")
        let detailedVC = SubmitViewController(nibName: "SubmitViewController", bundle: nil)
//
//        // detailedVC
        detailedVC.bus = buses[indexPath.row]
//        detailedVC.image = theImageCache[indexPath.row]
//        
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
