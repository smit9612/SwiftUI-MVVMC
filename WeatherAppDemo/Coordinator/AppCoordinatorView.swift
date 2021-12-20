//
//  AppCoordinatorView.swift
//  WeatherAppDemo
//
//  Created by smiteshP on 17/12/21.
//

import SwiftUI

struct AppCoordinatorView: View {
    @ObservedObject var coordinator: AppCoordinator

    var body: some View {
        CityListCoordinatorView(coordinator: coordinator.cityListCoordinator)
    }
}
