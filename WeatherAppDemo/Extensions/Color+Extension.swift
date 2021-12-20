//
//  Color+Extension.swift
//  WeatherAppDemo
//
//  Created by smiteshP on 17/12/21.
//

import Foundation

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color {
    static let borderStrokeColor = Color(.sRGB, red: 150 / 255, green: 150 / 255, blue: 150 / 255, opacity: 0.2)
    static let appBlack = Color("app-black")
    static let primaryButtonColor = Color("primaryButton")
    static let primaryButtonDisabledColor = Color("app-button-disabled")
    static let primaryButtonDisabledTextColor = Color(
        UIColor(red: 196 / 255,
                green: 196 / 255,
                blue: 196 / 255,
                alpha: 1)
    )
}
