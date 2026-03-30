//
//  WeatherView.swift
//  Weather
//
//  Created by Prasad Kukkala on 2/5/26.
//

import SwiftUI
import AVFoundation

struct WeatherView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @ObservedObject var forecastVM: ForecastViewModel
    
    init(viewModel: WeatherViewModel, forecastVM: ForecastViewModel) {
        self.viewModel = viewModel
        self.forecastVM = forecastVM
    }
    
    var body: some View {
        ZStack {
            DriftingBackground()
            VStack {
                loadContent
                Spacer()
                forecastView
            }
            
        }
    }
    
    @ViewBuilder
    var loadContent: some View {
        switch viewModel.weatherUIState {
        case .loading:
            ProgressView()
        case .success(let weather):
            weatherViewContent(weather: weather)
        case .failure(let string):
            Text(string)
                .font(Font.subheadline)
                .foregroundColor(.red)
        default:
            Text("Invalid state")
        }
    }
    
    @ViewBuilder
    func weatherViewContent(weather: WeatherResponse) -> some View {
        VStack {
            Text(weather.name)
                .font(.largeTitle)
            
            Text("\(Int((weather.main.temp - 273.15)))°")
                .font(.system(size: 25))
            
            Text(weather.weather.first?.description ?? "N/A")
                .font(.title)
                .font(.system(size: 30))
            
            Text("H:\(Int(weather.main.tempMax - 273.15))° / L:\(Int(weather.main.tempMin - 273.15))°")
                .font(.system(size: 20))
        }
    }
    
    @ViewBuilder
    var forecastView: some View {
        VStack {
            ForecastView(forecastVM: forecastVM)
        }
    }
}

struct LoopingVideoPlayer: UIViewRepresentable {
    //let videoName: String

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        guard let path = Bundle.main.path(forResource: "WeatherBackgroud", ofType: "mp4") else { return view }
        let url = URL(fileURLWithPath: path)
        
        let asset = AVURLAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        let player = AVQueuePlayer()
        let looper = AVPlayerLooper(player: player, templateItem: item)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        
        // Use a container to handle resizing
        context.coordinator.looper = looper
        player.play()
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        uiView.layer.sublayers?.first?.frame = uiView.bounds
    }

    class Coordinator { var looper: AVPlayerLooper? }
    func makeCoordinator() -> Coordinator { Coordinator() }
}

struct DriftingBackground: View {
    @State private var animate = false

    var body: some View {
        Image("WeatherBackgroud") //Use an image wider than the screen
            .resizable()
            .scaledToFill()
            .offset(x: animate ? -50 : 0)
            .ignoresSafeArea()
            .animation(
                .linear(duration: 30)
                .repeatForever(autoreverses: true),
                value: animate
            )
            .onAppear { animate = true }
    }
}
