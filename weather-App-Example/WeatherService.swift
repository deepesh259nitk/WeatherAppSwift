//
//  WeatherService.swift
//  weather-App-Example
//
//

import Foundation

//Name of the class doesn't have to match the class name always 

protocol WeatherServiceDelegate {
    
    //just function signature in protocol.
    func setWeather(weather: Weather)
    func weatherErrorWithMessage(message: String)
    
}

class WeatherService {
    
    var delegate : WeatherServiceDelegate?
    
    func getWeather(city: String){
        
        
        let cityEscaped = city.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        let appId = "a9dcb42650deea005a3fcdf466017a6e"
        
        let path = "http://api.openweathermap.org/data/2.5/weather?q=\(cityEscaped!)&appid=\(appId)"
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            
            if let httpResponse = response as? NSHTTPURLResponse{
                print("*******")
                print(httpResponse.statusCode)
                print("*******")
            }
        
            //print("data is \(data)")
            let json = JSON(data: data!)
            print(json)
            
            //get the code cod : 401 unauthorised, 404 : file not found, 200 ok !
            //open weather map returns 404 as a string but 401 and 200 as Int
            
            var status = 0
            
            if let cod = json["cod"].int{
                status = cod
            } else if let cod = json["cod"].string{
                status = Int(cod)!
            }
            
            print("weather status code :\(status)")
            
            if status == 200 {
                
                //everything is ok
                
                //let lon = json["coord"]["lon"].double
                //let lat = json["coord"]["lat"].double
                let temp = json["main"]["temp"].double
                let name = json["name"].string
                let desc = json["weather"][0]["description"].string
                let icon = json["weather"][0]["icon"].string
                let clouds = json["clouds"]["all"].double
                
                let weather = Weather(cityName: name!, temp: temp!, description: desc!,icon: icon!, clouds: clouds!)
                
                //get main thread first to update the UI. Always remember the main thread does the UI update
                if self.delegate != nil{
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.delegate?.setWeather(weather)
                        })
                }
                
            } else if status == 404 {
                
                // City not found
                if self.delegate != nil{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.delegate?.weatherErrorWithMessage("City Not Found")
                    })
                }

                
            } else {
                
                // some other problem 
                if self.delegate != nil{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.delegate?.weatherErrorWithMessage("Some Other Problem")
                    })
                }
    
            }
            
        }
        
        //resume here is starting the task.
        task.resume()
    
    }
}
