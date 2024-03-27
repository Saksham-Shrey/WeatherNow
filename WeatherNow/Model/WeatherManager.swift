//
//  WeatherManager.swift
//  WeatherNow
//
//  Created by Saksham Shrey on 24/03/24.
//

import UIKit

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let apiKey: String?
    
    init(apiKey: String?) {
        self.apiKey = apiKey
    }
    
    var delegate: WeatherManagerDelegate?

    func fetchWeather(cityName: String) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey ?? "")&units=metric&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
//                        print("\(weather.conditionId) : \(weather.cityName) : \(weather.conditionName) : \(weather.temperatureString)")
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }) //Closure ends here
            
            task.resume()
        }
    }
    
    func parseJSON (_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
//            print("\(name) : \(id) : \(weather.conditionName) : \(weather.temperatureString)")
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}

