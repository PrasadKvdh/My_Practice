//
//  ForecastView.swift
//  Weather
//
//  Created by Prasad Kukkala on 2/5/26.
//

import SwiftUI

struct ForecastView: View {
    @ObservedObject var forecastVM: ForecastViewModel
    @State var isShowingDetail: Bool = false
    let imageCache = ImageCache()
    
    init(forecastVM: ForecastViewModel) {
        self.forecastVM = forecastVM
    }
    
    var body: some View {
        loadContent
    }
    
    @ViewBuilder
    var loadContent: some View {
        switch forecastVM.uiState {
        case .loading:
            ProgressView()
        case .success:
            showHourlyForecasetView(forecasts: forecastVM.hourlyForecast)
            showDailyForecasetView(dailyForecasts: forecastVM.forecastByDate)
        case .failure(let string):
            Text(string)
                .font(Font.subheadline)
                .foregroundColor(.red)
        default:
            Text("Invalid state")
        }
    }
    
    @ViewBuilder
    func showHourlyForecasetView(forecasts: [DataList]) -> some View {
        VStack(alignment: .leading) {
            Text("Hourly forecast")
            ScrollView(.horizontal, showsIndicators: false) {
                Grid(alignment: .leading) {
                    GridRow {
                        if forecasts.isEmpty {
                            Text("No hourly forecast data to show")
                        } else {
                            ForEach(forecasts) { item in
                                VStack {
                                    Text(Date(timeIntervalSince1970: Double(item.dt)), format: .dateTime.hour())
                                        .font(.caption)
                                    image(icon: item.weather.first!.icon)
                                    Text("\(Int(item.main.temp - 273.15))°")
                                }
                                .frame(width: 50, height: 80)
                            }
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                )
                .onTapGesture {
                    isShowingDetail.toggle()
                }
                .sheet(isPresented: $isShowingDetail) {
                    DetailsView(response: forecasts)
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func showDailyForecasetView(dailyForecasts: [Day]) -> some View {
        VStack(alignment: .leading) {
            Grid {
                ForEach(dailyForecasts) { day in
                    Divider()
                    GridRow {
                        HStack {
                            Text(Calendar.current.isDateInToday(day.date) ? "Today" : day.date.formatted(.dateTime.weekday(.abbreviated)))
                                .padding()
                            Spacer()
                            image(icon: day.icon)
                            Spacer()
                            progressView(day: day)
                        }
                    }
                    .frame(height: 30)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
            )
        }
        .padding()
    }
    
    @ViewBuilder
    func image(icon: String) -> some View {
        AsyncImageView(imageName: icon)
    }
    
    @ViewBuilder
    func progressView(day: Day) -> some View {
        let lowValue = day.low-273
        let highValue = day.high-273
        
        Text("\(lowValue)°")
        RangeProgressView(rangeMin: Double(lowValue), rangeMax: Double(highValue))
        Text("\(highValue)°")
    }
}

struct RangeProgressView: View {
    var rangeMin: Double
    var rangeMax: Double
    var totalScale: Double

    init(rangeMin: Double, rangeMax: Double) {
        self.rangeMin = rangeMin
        self.rangeMax = rangeMax
        totalScale = rangeMin + rangeMax
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // 1. The full scale (1 to 10)
                    Capsule()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)

                    // 2. The active range (4 to 7)
                    Capsule()
                        .fill(Color.blue)
                        .frame(width: geo.size.width * ((rangeMax - rangeMin) / totalScale), height: 8)
                        // Offset moves the bar to start at "4"
                        .offset(x: geo.size.width * (rangeMin / totalScale))
                }
            }
            .frame(height: 8)
        }
        .padding()
    }
}
