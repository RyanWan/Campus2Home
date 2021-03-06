//
//  AfterSubmitViewController.swift
//  Map
//
//  Created by WENG on 16/12/2.
//  Copyright © 2016年 Ryan Wan. All rights reserved.
//

import UIKit

class AfterSubmitViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var planRouteButton: UIButton!
    var bus: String!
    var destinations: [String]!
    var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.destinations = ["olive", "pershing", "waterman"];
        let buttonColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
        planRouteButton.backgroundColor = buttonColor
        planRouteButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        setupTableView()
        tableView.addSubview(refreshControl)
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
        tableView.frame = CGRectMake(0, 70, self.view.frame.width, self.view.frame.height * 0.7);
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
        var destinations: [Destination] = []
        do {
            data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            print ("Finished")
            let json = JSON(data: data)
            print("json is \(json)")
            var route = json["route"]
            for i in 0...route.count-1 {
                var d:Destination! = Destination()
                
                d.address = route[i]["address"].stringValue
                d.x = Double(route[i]["x"].stringValue)!
                
                d.y = Double(route[i]["y"].stringValue)!
                
                destinations.append(d)
                
            }

        } catch{
            print ("FAULTED")
        }
        
        let detailedVC = MapViewController(nibName: "MapViewController", bundle: nil)
        detailedVC.flag = false
        detailedVC.destinations = destinations
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