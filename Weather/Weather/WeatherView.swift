//
//  WeatherView.swift
//  Weather
//
//  Created by Ikmal Harun on 25/01/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: WeatherViewModel

    init(viewModel: WeatherViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            Text("Weather Forecast")
                .font(.largeTitle)
                .bold()
                .padding().shadow(color: .white, radius: 3)
            TextField("Enter city name", text: $viewModel.cityName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if !viewModel.weatherDescription.isEmpty {
                VStack {
                    Text("City: \(viewModel.name)")
                        .font(.title3).bold()
                        .padding(.top)
                    
                    Text("Weather: \(viewModel.weatherDescription)")
                        .font(.title3).bold()
                        .padding(.top)
                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(viewModel.weatherIcon)@2x.png")) { image in
                        image.resizable().shadow(radius: 3)
                    } placeholder: {
                        Color.clear
                    }
                    .frame(width: 128, height: 128)
                    .clipShape(.rect(cornerRadius: 25))
                    Text("Temperature: \(viewModel.temperature)°C")
                        .font(.title3).bold()

                    Text("Humidity: \(viewModel.humidity)%")
                        .font(.title3).bold()
                        .padding(.bottom)
                    
                }
                .shadow(radius: 3)
                .frame(width: UIScreen.main.bounds.size.width).frame(height: 300)
                .background(Color.white).opacity(0.7)
            }
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .shadow(color: .white, radius: 1)
                    .font(.title2).bold()
                    .padding(.top)
                Image("Failed")
                    .resizable().scaledToFit()
            }
            Spacer()
        }
        .padding()
        .background(
            Image(viewModel.backgroundPicture)
                .resizable().scaledToFill()
                .edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    ContentView(viewModel: .init(weatherService: WeatherService()))
}
