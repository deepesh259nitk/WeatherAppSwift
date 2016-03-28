//
//  Weather.swift
//  weather-App-Example
//
//  Created by ITRMG on 2016-26-03.
//

import Foundation

struct Weather {
    
    //let are constants and cannot change. 
    
    
    let cityName : String
    let description : String
    let icon : String
    let clouds : Double
    let temp : Double
    
    init(cityName:String, temp:Double, description:String, icon:String, clouds:Double) {
        self.cityName = cityName
        self.temp = temp
        self.description = description
        self.icon = icon
        self.clouds = clouds
    }
    
    var tempC : Double {
        get{
            //return self.temp * 9/5 * 32
            return temp - 273.15
        }
    }
    
}