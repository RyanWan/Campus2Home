//
//  DestinationsViewController.swift
//  Shuttle2Home
//
//  Created by WENG on 16/11/11.
//  Copyright © 2016年 Wei Weng. All rights reserved.
//

import UIKit

class DestinationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var planRouteButton: UIButton!
    var bus: String!
    var destinations: [String]!
    var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttonColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
        planRouteButton.backgroundColor = buttonColor
        planRouteButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        setupTableView()
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        // Do any additional setup after loading the view.
    }
    
    func refresh_table(){
        var url:NSURL?
        url = NSURL(string: "http://localhost:5000/receive/\(bus)/update")
        let request = NSURLRequest(URL: url!)
        
        var data:NSData
        do {
            data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            print ("Finished")
            let json = JSON(data: data)
//            print("json is \(json)")
            var lists = json["address"].arrayValue
            destinations.removeAll()
            
            for item in lists{
                
                destinations.append(item.stringValue)
            }
        } catch{
            print ("FAULTED")
        }
        tableView.reloadData()
    }
    func refresh(sender:AnyObject){
        
        print("REFRESHING")
        refresh_table()
        print("REFRESHING FINISHED")
        refreshControl.endRefreshing()
    }
    
    func setupTableView() {
        
        tableView = UITableView(frame: view.frame.offsetBy(dx:0, dy: 100))
        tableView.frame = CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.height * 0.7);
        tableView.dataSource = self
        tableView.delegate = self
       
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        refresh_table()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return destinations.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let addressIcon = UIImage(named: "AddressIcon")
        
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "cell")
        cell.imageView?.image = addressIcon
        cell.textLabel!.text = destinations[indexPath.row]
//        cell.textLabel?.textColor = UIColor.whiteColor()
//        cell.backgroundColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let detailedVC = MapViewController(nibName: "MapViewController", bundle: nil)
//        navigationController?.pushViewController(detailedVC, animated: true)
        
    }
    
    @IBAction func startPlanRoute(sender: AnyObject) {
        var url:NSURL?
        url = NSURL(string: "http://localhost:5000/receive/\(bus)/route")
        let request = NSURLRequest(URL: url!)
        
        var data:NSData
        do {
            data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            print ("Finished")
            let json = JSON(data: data)
            print("json is \(json)")
            var route = json["route"]
        } catch{
            print ("FAULTED")
        }
        
        let detailedVC = MapViewController(nibName: "MapViewController", bundle: nil)
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
