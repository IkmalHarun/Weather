//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Ikmal Harun on 25/01/2025.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    // Input
    @Published var cityName: String = ""

    // Output
    @Published var name: String = ""
    @Published var weatherDescription: String = ""
    @Published var weatherIcon: String = ""
    @Published var temperature: String = ""
    @Published var humidity: String = ""
    @Published var backgroundPicture: String = "Background_General"
    @Published var errorMessage: String = ""
    
    
    private let weatherService: WeatherServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
        setupCityNameObserver()
    }

    private func setupCityNameObserver() {
        $cityName
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] city in
                if !city.isEmpty {
                    self?.fetchWeather(for: city)
                } else {
                    self?.clearWeatherData()
                }
            }
            .store(in: &cancellables)
    }

    private func fetchWeather(for city: String) {
        weatherService.fetchWeather(for: city)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = "Error fetching weather: \(error.localizedDescription)"
                    self?.clearWeatherData()
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] weatherResponse in
                self?.updateWeatherData(from: weatherResponse)
            })
            .store(in: &cancellables)
    }

    private func updateWeatherData(from response: WeatherResponse) {
        name = response.name
        weatherDescription = response.weather.first?.description.capitalized ?? "No description"
        weatherIcon = response.weather.first?.icon ?? ""
        temperature = String(format: "%.1f", response.main.temp)
        humidity = "\(response.main.humidity)"
        
        if weatherDescription.contains("Rain") {
            backgroundPicture = "Background_Raining"
        } else if weatherDescription.contains("Cloud") {
            backgroundPicture = "Background_Cloudy"
        } else if weatherDescription.contains("Sunny") || weatherDescription.contains("Clear") {
            backgroundPicture = "Background_Sunny"
        } else if weatherDescription.contains("Snow") {
            backgroundPicture = "Background_Snow"
        } else if weatherDescription.contains("Thunderstorm") {
            backgroundPicture = "Background_Thunderstorm"
        } else if weatherDescription.contains("Mist") {
            backgroundPicture = "Background_Mist"
        } else if weatherDescription.contains("Haze") {
            backgroundPicture = "Background_Haze"
        } else {
            backgroundPicture = "Background_General"
        }
        errorMessage = ""
    }

    private func clearWeatherData() {
        weatherDescription = ""
        temperature = ""
        humidity = ""
        backgroundPicture = "Background_General"
    }
}
