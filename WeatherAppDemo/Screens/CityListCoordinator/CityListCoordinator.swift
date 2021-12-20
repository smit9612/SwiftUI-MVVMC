//
//  CityListCoordinator.swift
//  WeatherAppDemo
//
//  Created by smiteshP on 17/12/21.
//

import SwiftUI

final class CityListCoordinator: ObservableObject {
    @Published var viewModel: CityListViewModel!
    @Published var cityDetailsViewModel: CityDetailsViewModel?

    init() {
        viewModel = .init(coordinator: self)
    }
    
    func openCityDetailsScreen(name: String) {
        cityDetailsViewModel = .init(coordinator: self, name: name)
    }
    
    func closeCityDetailsScreen() {
        cityDetailsViewModel = nil
    }
}
