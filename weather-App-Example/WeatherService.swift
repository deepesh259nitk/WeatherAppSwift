//
//  WeatherService.swift
//  weather-App-Example
//
//  Created by CTS on 3/25/16.
//  Copyright © 2016 cts. All rights reserved.
//

import Foundation

//Name of the class doesnt have to match the class name always 

protocol WeatherServiceDelegate {
    
    //just function signature in protocol.
    func setWeather(weather: Weather)
    
}

class WeatherService {
    
    var delegate : WeatherServiceDelegate?
    
    func getWeather(city: String){
        
        
        let cityEscaped = city.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        
        let path = "http://api.openweathermap.org/data/2.5/weather?q=\(cityEscaped!)&appid=a9dcb42650deea005a3fcdf466017a6e"
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
        
            //print("data is \(data)")
            let json = JSON(data: data!)
            let lon = json["coord"]["lon"].double
            let lat = json["coord"]["lat"].double
            let temp = json["main"]["temp"].double
            let name = json["name"].string
            let desc = json["weather"][0]["description"].string
            let icon = json["weather"][0]["icon"].string
            let clouds = json["clouds"]["all"].double
            
            print("lon is \(lon!)")
            print("lat is \(lat!)")
            print("temp is \(temp!)")
            print("name is \(name!)")
            print("desc is \(desc!)")
            
            let weather = Weather(cityName: name!, temp: temp!, description: desc!,icon: icon!, clouds: clouds!)
            
            
            //get main thread firt to update the UI. Always remember the main thred does the UI update 
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if self.delegate != nil{
                    self.delegate?.setWeather(weather)
                }
            })
            
            
            
        }
        
        //resume here is starting the task.
        task.resume()
        
        
        //print("Weather Service City : \(city)")
        
        //url :- api.openweathermap.org/data/2.5/weather?q=london&appid=a9dcb42650deea005a3fcdf466017a6e
        
        // Request weather data
        // wait
        // Process the data
        
        /*
        
        let weather = Weather(cityName: city, temp: 237.12, description: "A Nice Shiny Day")
        
        if delegate != nil {
            delegate?.setWeather(weather)
        }
        */
        
    }
}
