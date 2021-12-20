//
//  CityListCoordinatorView.swift
//  WeatherAppDemo
//
//  Created by smiteshP on 17/12/21.
//

import SwiftUI

struct CityListCoordinatorView: View {
    @ObservedObject var coordinator: CityListCoordinator

    var body: some View {
        NavigationView {
            CityListViewUI(viewModel: coordinator.viewModel)
                .navigationBarHidden(true)
                .navigation(item: $coordinator.cityDetailsViewModel) { viewModel in
                    CityDetailsViewUI(viewModel: viewModel)
                }
        }
        .edgesIgnoringSafeArea([.top, .bottom])
    }
}
