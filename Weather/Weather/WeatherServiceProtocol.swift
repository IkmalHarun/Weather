//
//  WeatherServiceProtocol.swift
//  Weather
//
//  Created by Ikmal Harun on 25/01/2025.
//

import Foundation
import Combine

protocol WeatherServiceProtocol {
    func fetchWeather(for city: String) -> AnyPublisher<WeatherResponse, Error>
}
