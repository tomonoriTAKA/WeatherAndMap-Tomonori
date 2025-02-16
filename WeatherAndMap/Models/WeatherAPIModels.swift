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
    // 2025-02-16 → 2025年2月16日 の形式に変換する関数
    func toDisplayDate(_ date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // 日付の形式を指定
        guard let date = formatter.date(from: date) else { return ""} //String→Date型に変換
        formatter.dateFormat = "yyyy年MM月dd日" // 変換後の日付の形式を指定
        return formatter.string(from: date)// Date型から指定した形式にしてString型に変換
    }
    
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
    
    // 時間毎の予報を表示用の構造体の形に変換
    func toDisplayFormat(hourlyForecast: HourlyForecast) -> HourlyDisplayForecast{
        let dateAndTime: (String, String) = splitTime(timeString: hourlyForecast.time)
        let displayWeather = HourlyDisplayForecast(
            date: dateAndTime.0,
            time: dateAndTime.1,
            weatherIcon: hourlyForecast.condition.icon,
            temperature: hourlyForecast.temperature,
            chanceOfRain: hourlyForecast.chanceOfRain
        )
        return displayWeather
    }
    // "2025-02-16 14:00" → "2025-02-16"と"14" に分割
    // timeに入っている「日時」の文字列→「日付」、「時間」に分割して(日付、時間)の文字列のタプルで返す。
    func splitTime(timeString: String) -> (String, String)  {
        var dateAndTimeString: (String, String) = ("----年--月--日", "--:--")
        // 日付と時刻のフォーマットを指定
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        // 文字列をDate型に変換
        if let date = dateFormatter.date(from: timeString) {
            // Calendarを使って日付と時刻を抽出
            let calendar = Calendar.current // ユーザーの現在の暦を取得
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            
            // 日付と時刻の文字列を作成
            let dateString = "\(components.year!)年\(components.month!)月\(components.day!)日"
            let timeString = "\(components.hour!)" // 何時だけを表示(例: 11)
            
            // print(dateString) // 出力形式: 2024年10月20日
            // print(timeString) // 出力形式: 11
            dateAndTimeString = (dateString, timeString)
            return dateAndTimeString
        } else {
            print("日付の変換に失敗しました")
            return dateAndTimeString
        }
    }
    
}

// 天気の説明とアイコン画像URL
struct Condition: Codable, Hashable {
    let text: String
    let icon: String
}


// 毎時予報の表示用の構造体
struct HourlyDisplayForecast: Identifiable {
    var id = UUID()
    let date: String
    let time: String
    let weatherIcon: String
    let temperature: Double
    let chanceOfRain: Double
}
