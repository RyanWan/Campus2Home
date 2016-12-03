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
    var apiKey = "AIzaSyA-zNnojD_2V81XAKp-AShKGNb32bRwtfI"
    var lat:String!
    var lng:String!
    var address:String!


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
        let addressText = addressTextField.text
        if (addressText != ""){
            let address = addressTextField.text?.stringByReplacingOccurrencesOfString(" ", withString: "+") as String?
            self.loadAndSendData(address!)
            let detailedVC = AfterSubmitViewController(nibName: "AfterSubmitViewController", bundle: nil)
            detailedVC.bus = self.bus
            navigationController?.pushViewController(detailedVC, animated: true)
        }
        

    }
    
    func loadAndSendData(searchText:String){
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED,0)){
           self.fetchData(searchText)
              dispatch_async(dispatch_get_main_queue()){
              var url:NSURL?
              print("http://localhost:5000/submit/\(self.bus)/\(self.address)/\(self.lat),\(self.lng)")
              url = NSURL(string: "http://localhost:5000/submit/\(self.bus)/\(self.address)/\(self.lat),\(self.lng)")
              let request = NSURLRequest(URL: url!)
              var data:NSData
              do {
                  data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
                  print ("Finished")
                    //                    let json = JSON(data: data)
                    //                    print("json is \(json)")
                    //                    var lists = json["address"]
                    //                    destinations.removeAll()
                    //
                    //                    for item in lists{
                    //                        destinations.append(String(item))
                    //                    }
                   } catch{
                      print ("FAULTED")
                   }
               }
           }
      }

    func fetchData(searchText:String){
        let json = getJSON("https://maps.googleapis.com/maps/api/geocode/json?address=\(searchText)&key=\(self.apiKey)")
        let jsonContent = json["results"].arrayValue

        if (jsonContent.count != 0){
            let result = jsonContent[0]
            self.address =  result["formatted_address"].stringValue.stringByReplacingOccurrencesOfString(" ", withString: "+") as String?
            self.lat = result["geometry"]["location"]["lat"].stringValue
            self.lng = result["geometry"]["location"]["lng"].stringValue
        }else {
            print("no result found")
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
