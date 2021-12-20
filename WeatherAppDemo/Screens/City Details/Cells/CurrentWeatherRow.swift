
import SwiftUI

struct CurrentWeatherRow: View {
    private let viewModel: CityDetailModel

    init(viewModel: CityDetailModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        todayWeatherView()
    }

    private func todayWeatherView() -> some View {
        VStack(spacing: 10) {
            Text("Today")
                .font(.largeTitle)
                .bold()
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("\(viewModel.temperature)℃")
                        .font(.system(size: 42))
                    Text("\(viewModel.humidity)")
                }
            }
        }
        .padding()
        .foregroundColor(.white)
        .background(RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.blue]), startPoint: .top, endPoint: .bottom))
                        .opacity(0.3))
        .shadow(color: .white.opacity(0.1), radius: 2, x: -2, y: -2)
        .shadow(color: .black.opacity(0.2), radius: 2, x: 2, y: 2)
    }

    
}
