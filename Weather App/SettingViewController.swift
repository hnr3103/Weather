//
//  SettingViewController.swift
//  Weather App
//
//  Created by Ravichandran HN on 3/20/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var days: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad();
        var ud = NSUserDefaults.standardUserDefaults()
        var city:String? = ud.objectForKey("city") as String?
        if(city == nil)
        {
            city = "Bangalore"
        }
        self.city.text = city;

        var days:UInt? = ud.valueForKey("days") as UInt?
        if(days == nil)
        {
            days = 3
        }
        self.days.text = "\(days!)"

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func save(sender: AnyObject) {
        var ud = NSUserDefaults.standardUserDefaults()
        if(self.city.text != nil)
        {
            ud.setObject(self.city.text, forKey: "city")
        }
        
        if(self.days.text != nil)
        {
            ud.setValue(self.days.text.toInt(), forKey: "days")
        }
        ud.synchronize()
        NSNotificationCenter.defaultCenter().postNotificationName("FORCE_REFRESH", object: nil)

        self.navigationController?.popViewControllerAnimated(true)
    }

}
