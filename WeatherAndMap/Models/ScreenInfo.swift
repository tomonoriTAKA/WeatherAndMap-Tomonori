//
//  ScreenInfo.swift
//  WeatherAndMap
//
//  Created by 高橋知憲 on 2025/02/16.
//

import Foundation
import SwiftUI

// スクリーンサイズ取得
struct ScreenInfo {
    // 画面を取得
    private static var window: UIWindowScene? {
        return UIApplication.shared.connectedScenes.first as? UIWindowScene
    }
    // 画面のbounds(座標、高さ、横幅を含んだもの)
    static var bounds: CGRect {
        return window?.screen.bounds ?? CGRect.zero
    }
    // 画面の横幅
    static var width: CGFloat {
        return bounds.width
    }
    // 画面の高さ
    static var height: CGFloat {
        return bounds.height
    }
}
