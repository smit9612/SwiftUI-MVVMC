
import Foundation
@testable import WeatherAppDemo

extension WeeklyForecastResponse {

	@MockedResponse<WeeklyForecastResponse>(type: .forecast)
	static var mockWeeklyForecast
}

extension CurrentWeatherForecastResponse {

	@MockedResponse<CurrentWeatherForecastResponse>(type: .weather)
	static var mockCurrentWeather
}

extension NearbyCitiesForeCastResponse {

	@MockedResponse<NearbyCitiesForeCastResponse>(type: .find)
	static var mockNearbyCities
}
