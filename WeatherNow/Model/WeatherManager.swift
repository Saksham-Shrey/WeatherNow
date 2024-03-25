//
//  WeatherManager.swift
//  WeatherNow
//
//  Created by Saksham Shrey on 24/03/24.
//

import UIKit


struct WeatherManager {
    
    let apiKey: String?
    
    init(apiKey: String?) {
        self.apiKey = apiKey
    }
    

    func fetchWeather(cityName: String) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey ?? "")&units=metric&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                print(error!)
                return
                }
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                }
            }) //Closure ends here
            
            task.resume()
        }
    }
    
    func parseJSON (weatherData: Data) {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print("\(decodedData.name) : \(decodedData.weather[0].description)")
        } catch {
            print(error)
        }
    }
    
}

