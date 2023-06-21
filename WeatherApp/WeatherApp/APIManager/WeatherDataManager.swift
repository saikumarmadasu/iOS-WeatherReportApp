//
//  WeatherDataManager.swift
//  WeatherReport
//
//  Created by SaiMadasu on 6/20/23.
//

import Foundation
import CoreLocation

struct WeatherDataManager {
    
    /// Weather report base URL
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=f615c188e7ea436abe50dd8a88e55fd5"
    
    
    
    /// Get weather data based on city name
    /// - Parameters:
    ///   - cityName: city name
    ///   - completionHandler: returns weather data
    func getWeatherDataFrom(_ cityName: String, completionHandler: @escaping (WeatherDataModel?) -> ()) {
        let urlString = "\(baseURL)&q=\(cityName)"
        let finalUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return self.fetchWeatherDataFromURL(finalUrl!, completionHandler: completionHandler)
    }
    
    /// Get weather data based in lattitude and longitude
    /// - Parameters:
    ///   - latitude: latitude
    ///   - longitute: longitute
    ///   - completionHandler: returns weather data
    func getWeatherDataFrom(_ latitude: Double, longitute: Double, completionHandler: @escaping (WeatherDataModel?) -> ()) {
        let urlString = "\(baseURL)&lon=\(longitute)&lat=\(latitude)"
        return self.fetchWeatherDataFromURL(urlString, completionHandler: completionHandler)
    }
    
    /// Fetch weather data from URL
    /// - Parameters:
    ///   - urlString: final url string
    ///   - completionHandler: returns weather data
    func fetchWeatherDataFromURL(_ urlString: String, completionHandler: @escaping (WeatherDataModel?) -> ()) {
        
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default)
            let task = urlSession.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    completionHandler(nil)
                    return
                }
                if let weatherData = data {
                    do {
                        let jsonData = try JSONSerialization.jsonObject(with: data!, options: [])
                        let weatherDataModel =  try JSONDecoder().decode(WeatherDataModel.self, from: weatherData)
                        
                        completionHandler(weatherDataModel)
                    }
                    catch{
                        print(error)
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            }
            task.resume()
        }
    }
}
