//
//  CityDetailsViewModel.swift
//  WeatherAppDemo
//
//  Created by smiteshP on 17/12/21.
//

import SwiftUI
import Combine

final class CityDetailsViewModel: ObservableObject, Identifiable, ManagerInjected {
    
    private var coordinator: CityListCoordinator?
    private var bag = Set<AnyCancellable>()

    @Published var loading = false
    @Published var cityDetailModel: CityDetailModel!
    @Published var weeklyWeatherForecast = [DailyWeatherRowViewModel]()
    @Published var isNoCityFound = false
    @Published var cityName = ""

    init(coordinator: CityListCoordinator, name: String) {
        self.coordinator = coordinator

        self.cityName = name
        searchCity(name: name)
        weeklyWeather(name: name)
    }


    private func searchCity(name: String) {
        loading = true
        forecastService.currentWeatherForecast(forCity: name)
            .map(CityDetailModel.init)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] value in
                    guard let self = self else { return }
                    self.loading = false
                    switch value {
                    case .failure:
                        self.isNoCityFound = true
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] forecast in
                    guard let self = self else { return }
                    self.loading = false
                    self.cityDetailModel = forecast
                }
            )
            .store(in: &bag)
    }

    private func weeklyWeather(name: String) {
        loading = true
        forecastService.weeklyWeatherForecast(forCity: name)
            .map { response in
                response.list.map(DailyWeatherRowViewModel.init)
            }
            .map(Array.removeDuplicates)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] value in
                    guard let self = self else { return }
                    self.loading = false
                    switch value {
                    case .failure:
                        self.isNoCityFound = true
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] forecast in
                    guard let self = self else { return }
                    self.loading = false
                    self.weeklyWeatherForecast = forecast
                }
            )
            .store(in: &bag)
    }

}
