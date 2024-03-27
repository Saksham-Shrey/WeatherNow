//
//  ViewController.swift
//  WeatherNow
//
//  Created by Saksham Shrey on 24/03/24.
//
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    var weatherManager = WeatherManager(apiKey: ProcessInfo.processInfo.environment["API_KEY"])
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        
        weatherManager.delegate = self              // It was not working and data was not reaching here because this current class was not set as the current/runtime delegate and hence nothing was printed as the didUpdateWeather function was not getting triggered from the WeatherManager
        
    }
    
    

    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text ?? "Paris")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchTextField.endEditing(true)

        print(searchTextField.text!)
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type City Name"
            return false
        }
            
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        temperatureLabel.text = weather.temperatureString
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

