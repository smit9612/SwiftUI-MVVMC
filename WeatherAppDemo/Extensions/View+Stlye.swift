//
//  View+Stlye.swift
//  WeatherAppDemo
//
//  Created by smiteshP on 18/12/21.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var radius: CGFloat
    init(radius: CGFloat) {
        self.radius = radius
    }
    
    func makeBody(configuration: Configuration) -> some View {
        PrimaryButtonStyleView(configuration: configuration, radius: radius)
    }
}

extension PrimaryButtonStyle {
    struct PrimaryButtonStyleView: View {
        @Environment(\.isEnabled) var isEnabled
        let configuration: PrimaryButtonStyle.Configuration
        let radius: CGFloat
        var body: some View {
            configuration.label
                .foregroundColor(isEnabled ? .white : Color.primaryButtonDisabledTextColor)
                .background(RoundedRectangle(cornerRadius: 5)
                            .fill(isEnabled ? Color.primaryButtonColor : Color.primaryButtonDisabledColor)
                )
                .opacity(configuration.isPressed ? 0.8 : 1.0)
                .cornerRadius(radius)
        }
    }
}
