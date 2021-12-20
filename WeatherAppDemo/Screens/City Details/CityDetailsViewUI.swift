//
//  CityDetailsViewUI.swift
//  WeatherAppDemo
//
//  Created by smiteshP on 17/12/21.
//

import SwiftUI

struct CityDetailsViewUI: View {
    @ObservedObject var viewModel: CityDetailsViewModel

    init(viewModel: CityDetailsViewModel) {
        self.viewModel = viewModel
        UITableView.appearance().separatorColor = .clear
    }
    
    var body: some View {
        ZStack {
            if let cityDetailModel = viewModel.cityDetailModel {
                List {
                    Header(cityDetailModel: cityDetailModel)
                    
                    ForEach(Array(viewModel.weeklyWeatherForecast.enumerated()), id: \.offset) { index, weeklyWeatherForecast in
                        DailyWeatherRow(viewModel: weeklyWeatherForecast)
                            .id(UUID())
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle(viewModel.cityName)
            }
            

            if viewModel.isNoCityFound {
                Text("No city found")
            }
        }
    }

    struct Header: View {
        var cityDetailModel: CityDetailModel
        
        var body: some View {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    MapView(coordinate: cityDetailModel.coordinate)
                        .cornerRadius(25)
                        .disabled(true)
                }
                .frame(height: 250, alignment: .center)
                
                CurrentWeatherRow(viewModel: cityDetailModel)
                    .padding(.top, 20)
                    .padding(.trailing, 10)
            }
        }
    }
}
