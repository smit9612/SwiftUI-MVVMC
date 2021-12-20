//
//  CityListViewModel.swift
//  WeatherAppDemo
//
//  Created by smiteshP on 17/12/21.
//

import SwiftUI
import Combine

final class CityListViewModel: ObservableObject, Identifiable, ManagerInjected {

    private let coordinator: CityListCoordinator
    
    @Published var searchKeyword: String = ""
    @Published var showSearchDetails: Bool = false
    @Published var citiesList = [CityModel]()

    let buttonTitle = LocalizedStringKey("cityListViewUI_search")
    @Published var buttonTitleIsDisable: Bool = true
    
    @ObservedObject var locationManager = LocationManager()
    @Published var loading = false
    @Published var lastUpdate: String = ""

    var isFirstResponder = false
    var bag = Set<AnyCancellable>()

    var userLatitude: Double = 35
    var userLongitude: Double = 138
    
    init(coordinator: CityListCoordinator) {
        self.coordinator = coordinator
        $searchKeyword
            .sink { [weak self] searchText in
                guard let self = self else { return }
                self.buttonTitleIsDisable = searchText.isEmpty
            }
            .store(in: &bag)

        locationManager.$lastLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let self = self else { return }
                self.userLatitude = (location?.coordinate.latitude ?? 0.0).round(to: 2)
                self.userLongitude = (location?.coordinate.longitude ?? 0.0).round(to: 2)
                self.refresh()
                //self.startTimer()
            }
            .store(in: &bag)
    }


    // func get current location lat and long using combine
    func startTimer() {
        Timer.publish(every: 60*3600, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.refresh()
            }
            .store(in: &bag)
    }

    func refresh() {
        lastUpdate = timeFormatter.string(from: Date())
        fetchNearBy()
    }

    func onSearchButtonPress() {
        openCityDetailsScreen(name: searchKeyword)
    }

    private func fetchNearBy() {
        loading = true
        forecastService.nearbyCurrentWeatherForecast(for: userLatitude, lon: userLongitude, count: 10)
            .map { response in
                response.list.map { CityModel(item: $0) }
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] value in
                    guard let self = self else { return }
                    self.loading = false
                    switch value {
                        case .failure:
                            self.citiesList = []
                        case .finished:
                            break
                    }
                },
                receiveValue: { [weak self] forecast in
                    guard let self = self else { return }
                    self.loading = false
                    self.citiesList = forecast
                }
            )
            .store(in: &bag)
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func clear() {
        searchKeyword = ""
    }
    
    func openCityDetailsScreen(name: String? = nil) {
        self.coordinator.openCityDetailsScreen(name: name ?? "")
    }
}

let timeFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM-dd-yy HH:mm a"
    dateFormatter.locale = Locale(identifier: "en-US")
    return dateFormatter
}()
