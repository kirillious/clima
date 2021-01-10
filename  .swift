//
//  File.swift
//  Clima
//
//  Created by Kirill on 03.12.2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//
// 7c728028a3ef006c77955c6619d2661c
import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager ,weather: WeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=7c728028a3ef006c77955c6619d2661c&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // 1.Create an URL
        
        if let url = URL(string: urlString) {
            
            // 2.Create an URLSession
            
            let session = URLSession(configuration: .default)
            
            // 3.Give a session a task
            
            let task = session.dataTask(with: url) {(data,response,error) in if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
                }
                
                if let safeData = data {
                    if let weather = parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
            }
        }
            
            
            // 4.Start the task
             task.resume()
        
}
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
       let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
            
        }
    }
    
        
    
}
}
