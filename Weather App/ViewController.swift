//
//  ViewController.swift
//  Weather App
//
//  Created by Ravichandran HN on 3/20/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

import UIKit



class ViewController: UITableViewController {

    var weatherList: [Weather?]? = [] ;
    
    @IBAction func doRefresh(sender: AnyObject) {
        
        
        var ud = NSUserDefaults.standardUserDefaults()
        var city:String? = ud.objectForKey("city") as String?
        if(city == nil)
        {
            city = "Bangalore"
            ud.setObject(city, forKey: "city")
        }
        
        var days:UInt? = ud.valueForKey("days") as UInt?
        if(days == nil)
        {
            days = 3
            ud.setValue(days, forKey: "days")
        }

        ud.synchronize()
        
        WeatherClient.sharedInstance.fetch(city, count: days) { (error, list) -> Void in
            println(list)
            if( error == nil){
                self.weatherList = list
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("doRefresh:"), name: "FORCE_REFRESH", object: nil)
        var footerView: UIView? = UIView()
        self.tableView.tableFooterView = footerView;
        self.doRefresh(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let array = self.weatherList{
            return array.count
        }
        return 0;
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var weatherCell : WeatherCell? = tableView.dequeueReusableCellWithIdentifier("weatherCell") as WeatherCell?
        if weatherCell == nil{
            weatherCell = WeatherCell(style:UITableViewCellStyle.Default,reuseIdentifier:"weatherCell");
        }
        if let main = self.weatherList?[indexPath.row]?.main{
            weatherCell?.title.text = main as String
        }
        if let desc = self.weatherList?[indexPath.row]?.wheatherDesc{
            weatherCell?.details.text = desc;
        }
        
        return weatherCell!;
        
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("detailVCSegue",sender: self)
        //settingsVCSegue
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "detailVCSegue"){
            var indexPath = self.tableView.indexPathForSelectedRow()
            var vc = segue.destinationViewController as DetailViewController
            vc.weather = self.weatherList?[indexPath!.row]
        }
    }
}

