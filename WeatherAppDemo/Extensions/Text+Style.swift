//
//  Text+Style.swift
//  WeatherAppDemo
//
//  Created by smiteshP on 18/12/21.
//

import SwiftUI

struct PrimaryButtonTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 8)
            .lineSpacing(4)
    }
}

extension Text {
    func textStyle<Style: ViewModifier>(_ style: Style) -> some View {
        ModifiedContent(content: self, modifier: style)
    }
}
