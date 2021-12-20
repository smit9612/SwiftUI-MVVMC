//
//  WeatherAppDemoApp.swift
//  WeatherAppDemo
//
//  Created by smiteshP on 17/12/21.
//

import SwiftUI

@main
struct WeatherAppDemoApp: App {

	@StateObject var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
			AppCoordinatorView(coordinator: coordinator)
        }
    }
}
