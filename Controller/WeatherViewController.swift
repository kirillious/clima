//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
   
 

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    
    @IBOutlet weak var searchField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        searchField.delegate = self
        weatherManager.delegate = self
    }
    
    
    @IBAction func getMyLocation(_ sender: UIButton) {
        
//        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
    }
    
}




//MARK: - UITextFieldDelegate


extension WeatherViewController: UITextFieldDelegate {
     
    @IBAction func searchPressed(_ sender: UIButton) {
         print(searchField.text ?? "fck off")
         searchField.endEditing(true)
     }
     
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         
         print(textField.text ?? "print smt")
         searchField.endEditing(true)
         return true
     }
     
     func textFieldDidEndEditing(_ textField: UITextField) {
         if let city = searchField.text {
             weatherManager.fetchWeather(cityName: city)
         }
         searchField.text = ""
     }

     func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
         if textField.text != "" {
             textField.placeholder = "Search"
             return true
         } else {
             textField.placeholder = "bro, feed me some info"
             return false
         }
     }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager ,weather: WeatherModel ) {
        
        
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
}


//MARK: - CCLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


