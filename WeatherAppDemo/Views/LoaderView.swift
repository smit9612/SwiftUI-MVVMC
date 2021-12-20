//
//  LoaderView.swift
//  WeatherAppDemo
//
//  Created by smiteshP on 19/12/21.
//

import SwiftUI

struct LoaderView: View {
    var tintColor: Color = .blue
    var scaleSize: CGFloat = 1.0
    
    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            Spacer()
            HStack(alignment: .center, spacing: 0) {
                Spacer()
                ProgressView()
                    .scaleEffect(scaleSize, anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
                Spacer()
            }
            Spacer()
        })
    }
}
