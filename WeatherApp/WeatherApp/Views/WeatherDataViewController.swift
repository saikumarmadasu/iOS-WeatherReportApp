//
//  WeatherDataViewController.swift
//  WeatherReport
//
//  Created by SaiMadasu on 6/20/23.
//

import UIKit
import CoreLocation

class WeatherDataViewController: UIViewController {

    // MARK: IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherIconImageVoew: UIImageView!
    @IBOutlet weak var tempretureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var minMaxTempretureLabel: UILabel!
    
    // MARK: Class Variables
    var viewModel = WeatherDataViewModel()
    var locationManager = CLLocationManager()

    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Weather Report"
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        viewModel.delegate = self
        self.updateLastSavedWeatherData()
    }
    
    // MARK: Private functions
    func updateLastSavedWeatherData() {
        self.didUpdateWeatherData(viewModel.getLastSavedWeatherData())
    }
    
    /// Reset UI when we failed to get the data from API
    func resetUI() {
        self.cityNameLabel.text = ""
        self.tempretureLabel.text = ""
        self.descriptionLabel.text = ""
        self.weatherIconImageVoew.image = UIImage(named: "")
        self.minMaxTempretureLabel.text = "Unable to get the data from server"
    }
    
    // MARK: IBActions
    @IBAction func didTapOnLocationButton(_ sender: UIButton) {
        self.view.endEditing(true)
        locationManager.requestLocation()
    }
    
    @IBAction func didTapOnSearchButton(_ sender: UIButton) {
        self.view.endEditing(true)
        if let cityName = searchBar.text, !cityName.isEmpty {
            viewModel.getWeatherDatafrom(cityName: cityName)
        }
    }
}

// MARK: CLLocationManagerDelegate
extension WeatherDataViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let longitude = location.coordinate.longitude
            let latitude = location.coordinate.latitude
            viewModel.getWeatherDatafrom(lattitude: latitude, longitude: longitude)
        }
    
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: WeatherDataViewModelDelegate
extension WeatherDataViewController: WeatherDataViewModelDelegate {
    
    /// Update UI based on weather data
    /// - Parameter weatherDataModel: weatherDataModel object
    func didUpdateWeatherData(_ weatherDataModel:  WeatherDataModel?) {
       
            guard let weatherDataModel = weatherDataModel else {
                self.resetUI()
                return
            }
        guard let weather = weatherDataModel.weather.first else { return }
        DispatchQueue.main.async {
            self.cityNameLabel.text = weatherDataModel.name
            self.tempretureLabel.text = String(weatherDataModel.main.temp) + "°"
            
           
            self.descriptionLabel.text = weather.description
           
            self.minMaxTempretureLabel.text = "H:" + String(weatherDataModel.main.temp_min) + "°  " + "L:" + String(weatherDataModel.main.temp_max) + "°"
        }
        let imgUrl = URL(string: "https://openweathermap.org/img/wn/\(weather.icon)@2x.png")
        downloadImage(from: imgUrl!)
        
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.weatherIconImageVoew.image = UIImage(data: data)
            }
        }
    }

}

