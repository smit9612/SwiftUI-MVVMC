//
//  WeeklyModel.swift
//  WeatherAppDemo
//
//  Created by Smitesh Patel on 2021-12-18.
//

import Foundation

struct WeeklyModel {
    let name: String

    init(item: WeatherItem) {
        name = item.name ?? ""
    }
}
