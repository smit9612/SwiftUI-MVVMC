
import SwiftUI

struct DailyWeatherRow: View {
    private let viewModel: DailyWeatherRowViewModel

    init(viewModel: DailyWeatherRowViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

        VStack(spacing: 10) {
            DailyInfoView()
            DailyWeatherView()
        }.padding()
            .foregroundColor(.white)
            .background(RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.blue]), startPoint: .top, endPoint: .bottom))
                            .opacity(0.3))
            .shadow(color: .white.opacity(0.1), radius: 2, x: -2, y: -2)
            .shadow(color: .black.opacity(0.2), radius: 2, x: 2, y: 2)
    }

    private func DailyInfoView() -> some View {
        HStack {
            VStack {
                Text("\(viewModel.day)")
                Text("\(viewModel.month)")
            }

            LottieView(name: viewModel.weatherIconLottieFileName ?? "", loopMode: .loop)
                .frame(width: 100, height: 100)

            Text("\(viewModel.temperature)°")
                .font(.title)
        }
    }

    private func DailyWeatherView() -> some View {
        HStack {
            WidgetView(image: "wind", color: .green, title: "\(viewModel.windSpeed)")
            Spacer()
            WidgetView(image: "drop.fill", color: .blue, title: "\(viewModel.humidity)")
            Spacer()
            WidgetView(image: "umbrella.fill", color: .red, title: "\(viewModel.precipitation)")
        }
    }

    private func WidgetView(image: String, color: Color, title: String) -> some View {
        VStack{
            Image(systemName: image)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding(.all, 15)
                .font(.title)
                .foregroundColor(color)
                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                .frame(width: 60, height: 60)
            
            Text(title)
                .font(.system(size: 14))
        }
        .frame(height: 120)
    }
}
