//
//  LocationManager.swift
//  WeatherAndMap
//
//  Created by 高橋知憲 on 2025/02/16.
//

import SwiftUI
import MapKit

class LocationManager: NSObject, ObservableObject {
    @Published var location: CLLocation? // 位置情報
    @Published var address: String = ""  // 住所
    private let locationManager = CLLocationManager() //ロケーションマネージャをインスタンス化
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest//位置情報の精度を最高に
        locationManager.distanceFilter = 100.0          // 更新する間隔(100mごとに)
        locationManager.requestWhenInUseAuthorization() // 位置情報の使用許可の要求
        locationManager.startUpdatingLocation()         // 位置情報の更新の開始
        locationManager.delegate = self                 // デリゲートをこのクラス(自分)に指定
    }
    // 位置情報取得の要求の関数
    func requestLocation(){
        locationManager.requestLocation()
    }
}

// LocationManagerのデリゲートだよ
extension LocationManager: CLLocationManagerDelegate {
    // 位置情報が更新されたときに実行される関数
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }//最新の位置情報があるかチェック
        self.location = location //@Published変数のlocationに最新の位置情報を渡す
        getAddressFromLocation(location: location) //最新の位置情報から住所を取得
    }
    
    // 位置情報の取得に失敗したとき
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)") // エラーの内容を出力
    }
    
    // 位置情報から住所を取得する関数
    private func getAddressFromLocation(location: CLLocation) {
        let geocoder = CLGeocoder() // ジオコーダーを用意
        
        // ここから逆ジオコーディング(位置情報→住所)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            
            // エラーが無いかチェック
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            // 場所の名前や住所等の情報があるかチェック
            guard let placemark = placemarks?.first else {
                print("No placemark found")
                return
            }
            
            // 場所の名前や住所等をカンマ区切りで1つのStringに
            let address = [
                //  placemark.country
                //  placemark.postalCode,
                placemark.administrativeArea,
                placemark.locality,
                placemark.subLocality/*,*/
                // placemark.thoroughfare,
                // placemark.subThoroughfare,
            ].compactMap { $0 }.joined(separator: ", ")
            
            // @Published変数のaddressに場所の名前等のStringを渡す
            DispatchQueue.main.async {
                self.address = address
                print(address)
            }
        }
    }
}




