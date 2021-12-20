//
//  PrimaryButton.swift
//  WeatherAppDemo
//
//  Created by smiteshP on 18/12/21.
//

import SwiftUI

struct PrimaryButton: View {
    var isDisabled: Bool
    var radius: CGFloat = 24
    var btnText: LocalizedStringKey
    var action: () -> Void
    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack(alignment: .center, spacing: 0, content: {
                Text(btnText)
                    .textStyle(PrimaryButtonTextStyle())
                    .foregroundColor(isDisabled ? Color.primaryButtonDisabledTextColor : Color.white)
            }).contentShape(Rectangle()).frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: 48,
                alignment: .center
            )
        })
        .buttonStyle(PrimaryButtonStyle(radius: radius))
    }
}
