//
//  ContentView.swift
//  WeatherAndMap
//
//  Created by 高橋知憲 on 2025/02/15.
//

import SwiftUI

struct ContentView: View {
    // APIへリクエストしたり、レスポンスの値を保持するオブジェクト
    @StateObject private var weatherVM = WeatherViewModel()
    @StateObject var locationManager = LocationManager()//位置情報管理のオブジェクト
    // 八幡平市大更の緯度・経度
    var lat: Double = 35.6895014 //39.91167
    var lon: Double = 139.6917337//141.093459
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    DailyWeatherView(weatherVM: weatherVM)
                    HourlyWeatherView(weatherVM: weatherVM)
                }
                .padding()
            }
            .navigationTitle("現在地: \(locationManager.address)")// 画面上部のタイトル
            .navigationBarTitleDisplayMode(.inline) //タイトルの書式
            
        }
        .padding()
        // 画面が表示されたときに実行される
        .onAppear {
            getWeatherForecast()
        }
    }
    // 現在地の天気予報取得、順番に処理したいのでDispatchQueue.main.async使用
    func getWeatherForecast() {
        DispatchQueue.main.async {
            if let location = locationManager.location {
                let latitude = location.coordinate.latitude     // 緯度
                let longitude = location.coordinate.longitude   // 軽度
                weatherVM.request3DaysForecast(lat: latitude, lon: longitude) // 天気リクエスト
                print("LAT:", latitude, "LON:", longitude)
            } else {
                print("getting weather is failed")
            }
        }
    }
}
#Preview {
    ContentView()
}
