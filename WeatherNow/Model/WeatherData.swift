//
//  WeatherData.swift
//  WeatherNow
//
//  Created by Saksham Shrey on 25/03/24.
//

import UIKit

struct WeatherData: Decodable {
    let name: String,
        main: Main,
        weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
}


