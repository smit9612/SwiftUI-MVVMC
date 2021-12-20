//
//  ServiceLocator.swift
//  sinapiaba employee
//
//  Created by Smitesh Patel on 2021-06-25.
//  Copyright © 2021 orgName. All rights reserved.
//

import Foundation


protocol ManagerInjected {}

extension ManagerInjected {

    var forecastService: ForecastService {
        return ManagerInjector.forecastService
    }
}

struct ManagerInjector {

    static var forecastService: ForecastService = ForecastServiceImpl()
}
