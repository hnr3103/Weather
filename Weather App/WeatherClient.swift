//
//  WeatherClient.swift
//  Weather App
//
//  Created by Ravichandran HN on 3/20/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

import Foundation


class WeatherClient :NSObject
{
    class var sharedInstance: WeatherClient {
        struct Static{
            static let instance: WeatherClient? = WeatherClient();
        }
        return Static.instance!
    }
    
    func fetch(city: String?, count: UInt?, callback:( (NSError?, [Weather?]?) -> Void)? )
    {
        let request: WeatherRequest = WeatherRequest()
        request.request(city, count: count) { (error, data) -> Void in
            
            if error != nil
            {
                if let c = callback
                {
                    c(error, nil);
                }
            }
            
            var response = WeatherResponse();
            response.parse(data, callback: callback)
        }
    }
}


class WeatherRequest :NSObject
{
    func request(city: String?, count: UInt?, callback: ( (NSError?, NSData?) -> Void)? )
    {
        if city != nil && count != nil{
            let url: NSURL? = NSURL(string: "http://api.openweathermap.org/data/2.5/forecast/daily?q=\(city!)&cnt=\(count!)&mode=json")
            let req: NSURLRequest = NSURLRequest(URL: url!)
            NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()) { (resp, data, error) -> Void in
                if let cb = callback
                {
                    cb(error,data)
                }
            }
            
        }
    }
}


class WeatherResponse : NSObject
{
    func parse(data : NSData?, callback: ( (NSError?, [Weather?]?) -> Void)? )
    {
        var weatherArray: [Weather?]? = []

        if let d = data
        {
            var result =  NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary?
            
            let statusCode = result?["cod"] as String?
            if statusCode == nil || statusCode! != "200"{
             
                if let c = callback{
                    c(NSError(domain: "Status Error", code: 0, userInfo: nil),nil)
                }
                return
            }
            
            var list = result?["list"] as NSArray?
            
            if let listArray = list {
                for items in listArray
                {
                    let weatherList = items["weather"] as NSArray?
                    if let weathers = weatherList{
                        
                        for w in weathers {
                            var weather: Weather = Weather();
                            weather.wheatherDesc = w["description"] as String?
                            weather.main = w["main"] as String?
                            weatherArray?.append(weather)
                        }
                    }
                }
            }
        }
        
        if let c = callback {
            c(nil,weatherArray)
        }

    }
}

