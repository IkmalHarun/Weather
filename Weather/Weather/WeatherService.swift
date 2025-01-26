//
//  WeatherService.swift
//  Weather
//
//  Created by Ikmal Harun on 25/01/2025.
//

import Foundation
import Combine

class WeatherService: WeatherServiceProtocol {
    private let apiKey = "3a743c581ecfbc0c51749a34993f823a"

    func fetchWeather(for city: String) -> AnyPublisher<WeatherResponse, Error> {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
