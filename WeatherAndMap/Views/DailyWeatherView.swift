//
//  DailyWeatherView.swift
//  WeatherAndMap
//
//  Created by 高橋知憲 on 2025/02/16.
//

import SwiftUI

struct DailyWeatherView: View {
    @ObservedObject var weatherVM: WeatherViewModel // APIレスポンスの値を保持するオブジェクト
    
    var body: some View {
        ScrollView(.horizontal) { // 水平方向にスクロール
            // レスポンスに天気予報の情報があるかどうかで場合分け
            if let forecastsDay = weatherVM.forecast?.forecastsDay {
                HStack {
                    ForEach(forecastsDay, id: \.self) { forecastDay in
                        // MARK: 1日分の天気予報のUI
                        VStack(spacing: 5) {
                            Text(forecastDay.toDisplayDate(forecastDay.date)) // 日付(年月日)
                                .font(.callout)
                            
                            AsyncImageView(urlStr: "https:\(forecastDay.day.condition.icon)")
                                .padding()
                                .scaledToFit()
                            
                            
                            Text(forecastDay.day.condition.text) // 天気の説明(晴れ、曇り 等)
                                .font(.headline)
                            // 最高気温 / 最低気温
                            HStack {
                                Text(forecastDay.day.maxTemp, format: .number) // 数字が入る
                                    .foregroundStyle(.red)
                                Text("°C")
                                    .foregroundStyle(.red)
                                
                                Text("/")
                                
                                Text(forecastDay.day.minTemp, format: .number) // 数字が入る
                                    .foregroundStyle(.blue)
                                Text("°C")
                                    .foregroundStyle(.blue)
                            }
                            // 降水確率
                            HStack {
                                Text("降水確率:")
                                Text(forecastDay.day.dailyChanceOfRain, format: .number) // 数字が入る
                                Text("%")
                            }
                            .font(.subheadline)
                            
                            
                        }
                        .padding()
                        .frame(width: ScreenInfo.width / 2,
                               height: ScreenInfo.height / 3)
                        .background(.yellow.opacity(0.3))   // 背景色、透過率を設定
                        .clipShape(.rect(cornerRadius: 10)) // 角丸に切り取る
                    }
                }
            } else {
                // コピペした部分。データが無い時(または起動直後)に表示
                HStack {
                    ForEach(0...2, id: \.self) { _ in
                        // MARK: 1日分の天気予報のUI
                        VStack(spacing: 5) {
                            Text("____年__月__日") // 日付(年月日)
                            Image(systemName: "cloud.sun") //天気アイコン(サンプル画像)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 64, height: 64)
                            Text("晴れのち曇り") // 天気の説明(晴れ、曇り 等)
                            // 最高気温 / 最低気温
                            HStack {
                                Text("最高") // 数字が入る
                                Text("°C /")
                                Text("最低") // 数字が入る
                                Text("°C")
                            }
                            // 降水確率
                            HStack {
                                Text("降水確率:")
                                Text("○○") // 数字が入る
                                Text("%")
                            }
                        }
                        .padding()
                        .frame(width: ScreenInfo.width / 2,
                               height: ScreenInfo.height / 3)
                        .background(.yellow.opacity(0.3))   // 背景色、透過率を設定
                        .clipShape(.rect(cornerRadius: 10)) // 角丸に切り取る
                    }
                }
            }
        }
    }
}

    
    
#Preview {
    @Previewable @StateObject var weatherVM = WeatherViewModel()
    // 八幡平市大更の緯度・経度
    let lat: Double = 39.91167
    let lon: Double = 141.093459
    
    DailyWeatherView(weatherVM: weatherVM)
        .onAppear {
            weatherVM.request3DaysForecast(lat: lat, lon: lon)
        }
}
