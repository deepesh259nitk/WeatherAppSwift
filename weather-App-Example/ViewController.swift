//
//  ViewController.swift
//  weather-App-Example
//
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, WeatherServiceDelegate {

    let weatherservice = WeatherService()
    let locationManager = CLLocationManager()
    
    
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
    
    // MARK: Location
    
    func getGPSLocation() {
        print("Starting location Manager")
        locationManager.startUpdatingLocation()
    }
    
    // 6 Add delegate methods
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        // Get weather for location
        print("Did update To Location")
        print(newLocation)
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did update locations")
        print(locations)
        //self.weatherservice
        //self.weatherService.getWeatherForLocation(locations[0])
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("location error \(error) \(error.userInfo)")
    }
    

    
    // Mark :- Weather Service Delegate Methods
    
    func setWeather(weather: Weather) {
        
        print("**** set weather")
        print("city :\(weather.cityName) temp:\(weather.temp) description:\(weather.description)")
       
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        
        let f = formatter.stringFromNumber(weather.tempC)!
        
        tempLabel.text = "\(f)"
        
        descLabel.text = weather.description
        cityButton.setTitle(weather.cityName, forState: .Normal)
        cloudImage.image = UIImage(named: weather.icon)
        cloudsLabel.text = "Clouds : \(weather.clouds)%"
    }
    
    func weatherErrorWithMessage(message:String){
       
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func openCityAlert(){
        
        //Create Alert Controller. 
        let alert = UIAlertController(title: "City",
            message: "Enter City Name",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        //create location Action.
        let location = UIAlertAction(title: "Use Location", style: .Default) { (action: UIAlertAction) -> Void in
            //
            self.getGPSLocation()
        }
        
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
        alert.addAction(location)
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

