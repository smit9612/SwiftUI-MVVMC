//
//  AppCoordinator.swift
//  WeatherAppDemo
//
//  Created by Smitesh Patel on 2021-12-17.
//

import Foundation
import SwiftUI

final class AppCoordinator: ObservableObject {

	@Published var cityListCoordinator: CityListCoordinator!
    
	init() {
		cityListCoordinator = CityListCoordinator()
	}
}

