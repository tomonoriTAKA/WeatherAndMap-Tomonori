//
//  WeatherAPIModels.swift
//  WeatherAndMap
//
//  Created by 高橋知憲 on 2025/02/15.
//

import Foundation

// レスポンス全体の大枠
struct WeatherInfo: Codable {
    let location: UserLocation
    let forecast: Forecast
}

// MARK: - ユーザーの位置とそれに関連した情報
struct UserLocation: Codable {
    let name: String
    let region: String
    let country: String
    let timezoneID: String
    let localTime: String
    
    // キャメルケース⇔スネークケースの相互変換するための記述
    enum CodingKeys: String, CodingKey {
        case name
        case region
        case country
        case timezoneID = "tz_id"
        case localTime = "localtime"
    }
}


// MARK: - 天気予報の情報全体
struct Forecast: Codable {
    // 取得した日数分の予報
    let forecastsDay: [ForecastDay]
    
    // Swift: forecastsDay ⇔ API: "forecastday"変換の記述
    enum CodingKeys: String, CodingKey {
        case forecastsDay = "forecastday"
    }
}

// 1日分の予報(1日と時間毎)
struct ForecastDay: Codable, Hashable {
    let date: String
    let day: DailyForecast
    let hour: [HourlyForecast]
}

// 日毎の予報
struct DailyForecast: Codable, Hashable {
    let maxTemp: Double
    let minTemp: Double
    let dailyChanceOfRain: Double
    let condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case maxTemp = "maxtemp_c"
        case minTemp = "mintemp_c"
        case dailyChanceOfRain = "daily_chance_of_rain"
        case condition
    }
}

// 時間毎の予報
struct HourlyForecast: Codable, Hashable{
    let time: String
    let temperature: Double
    let condition: Condition
    let chanceOfRain: Double
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature = "temp_c"
        case condition
        case chanceOfRain = "chance_of_rain"
    }
}

// 天気の説明とアイコン画像URL
struct Condition: Codable, Hashable {
    let text: String
    let icon: String
}


