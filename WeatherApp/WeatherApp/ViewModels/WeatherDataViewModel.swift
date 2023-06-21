//
//  WeatherDataViewModel.swift
//  WeatherReport
//
//  Created by SaiMadasu on 6/20/23.
//

import Foundation


enum WeatherDataType: String, CodingKey {
case cityName = "cityName"
case Locale = "locaion"
}

// MARK: ViewModel Delegate
protocol WeatherDataViewModelDelegate {
    func didUpdateWeatherData(_ weatherDataModel:  WeatherDataModel?)
}

class WeatherDataViewModel {
    
    // MARK: Class Variables
    var  weatherDataManager = WeatherDataManager()
    var delegate : WeatherDataViewModelDelegate?
    
    /// Get weather data based opmn city name
    /// - Parameter cityName: city name
    func getWeatherDatafrom(cityName: String) {
        weatherDataManager.getWeatherDataFrom(cityName) { weatherData in
            self.delegate?.didUpdateWeatherData(weatherData)
            self.saveCurrentWeatherReportData(weatherData)
        }
    }
    
    /// Get weather data based on lattitude and longitude
    /// - Parameters:
    ///   - lattitude: lattitude value
    ///   - longitude: longitude value
    func getWeatherDatafrom(lattitude: Double, longitude: Double) {
        weatherDataManager.getWeatherDataFrom(lattitude, longitute: longitude) { weatherData in
            self.delegate?.didUpdateWeatherData(weatherData)
            self.saveCurrentWeatherReportData(weatherData)
        }
    }
    
    /// Save current weather data to display while alunching the app
    /// - Parameter weatherDataModel: weather data model object
    func saveCurrentWeatherReportData(_ weatherDataModel:  WeatherDataModel?) {
        guard let weatherDataModel = weatherDataModel else { return }
        do {
            let encoder = JSONEncoder()
            let encodedWeatherDataModel = try encoder.encode(weatherDataModel)
            UserDefaults.standard.set(encodedWeatherDataModel, forKey: "weatherData")
            UserDefaults.standard.synchronize()
        } catch {
            print("unable to store data")
        }
    }
    
    /// Get Last saved weather data
    /// - Returns: return last saved weather data model object
    func getLastSavedWeatherData() -> WeatherDataModel? {
        let decoder = JSONDecoder()
        if let decodedWeatherDataModel = UserDefaults.standard.data(forKey: "weatherData") {
            do {
                let weatherDataModel = try decoder.decode(WeatherDataModel.self, from: decodedWeatherDataModel)
                return weatherDataModel
            } catch {
                print("unable to get stored data")
                return nil
            }
        }
        return nil
    }
}
