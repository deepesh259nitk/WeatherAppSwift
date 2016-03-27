//
//  ViewController.swift
//  weather-App-Example
//
//  Created by CTS on 3/25/16.
//  Copyright © 2016 cts. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WeatherServiceDelegate {

    let weatherservice = WeatherService()
    
    
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var cloudImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityButton: UIButton!
    
    @IBAction func setCityTapped(sender: UIButton) {
        
        //print("City Button Tapped")
        //call pop alert method.
        openCityAlert()
        
    }
    
    // Mark :- Weather Service Delegate
    
    func setWeather(weather: Weather) {
        
        print("**** set weather")
        print("city :\(weather.cityName) temp:\(weather.temp) description:\(weather.description)")
       
        //cityLabel.text = weather.cityName
        tempLabel.text = "\(weather.temp)"
        descLabel.text = weather.description
        cityButton.setTitle(weather.cityName, forState: .Normal)
        cloudImage.image = UIImage(named: weather.icon)
        cloudsLabel.text = "Clouds : \(weather.clouds)%"
    }
    
    
    func openCityAlert(){
        
        //Create Alert Controller. 
        let alert = UIAlertController(title: "City",
            message: "Enter City Name",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        //Create Cancel Action 
        let cancel = UIAlertAction(title:"Cancel",
            style: UIAlertActionStyle.Cancel ,
            handler: nil)
        
        
        alert.addAction(cancel)
        
        //Create OK Action 
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action:UIAlertAction) -> Void in
            
            print("ok tapped")
            
            let textField = alert.textFields?[0]
            print(textField?.text)
            
            //self.cityLabel.text = textField?.text
            let cityName = textField?.text
            self.weatherservice.getWeather(cityName!)
            
            
            
        }
        
        alert.addAction(ok)
        
        // Add text field. 
        
        alert.addTextFieldWithConfigurationHandler { (textField:UITextField) -> Void in
            
            textField.placeholder = "City Name"
            
        }
        
        self.presentViewController(alert, animated:true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.weatherservice.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

