//
//  AppTheme.swift
//  FinalTodo
//
//  Created by t2023-m0087 on 10/25/23.
//

import Foundation
import UIKit

// 테마를 나타내는 열거형
enum AppTheme {
    case theme1
    case theme2
    case theme3
    case theme4
    case theme5
}

// 테마 관리자 클래스
class ThemeManager {
    static var currentTheme: AppTheme = .theme1 {
        didSet {
            // 테마가 변경되면 이벤트를 발생시키고 UI에 적용합니다.
            NotificationCenter.default.post(name: .themeDidChangeNotification, object: currentTheme)
        }
    }
    
    // 다른 관련 기능 및 저장 로직을 포함할 수 있습니다.
}

// 앱에서 테마 변경을 감지하는 알림
extension Notification.Name {
    static let themeDidChangeNotification = Notification.Name("com.yourapp.themeDidChangeNotification")
}


struct CustomTheme {
    static var firstColor: UIColor? = .blue
    static var secondColor: UIColor? = .green
    // 다른 스타일 관련 정보 추가
}

//
//extension Color {
//    
//    static let theme11 = Color("theme01PointColor01")
//    static let theme12 = Color("theme01PointColor02")
//    static let theme13 = Color("theme01PointColor03")
//    
//    static let theme21 = Color("theme02PointColor01")
//    static let theme22 = Color("theme02PointColor02")
//    
//    static let theme31 = Color("theme03PointColor01")
//    static let theme32 = Color("theme03PointColor02")
//    
//    static let theme41 = Color("theme04PointColor01")
//    static let theme42 = Color("theme04PointColor02")
//    
//    static let theme51 = Color("theme05PointColor01")
//    static let theme52 = Color("theme05PointColor02")
//
//}

extension UIColor {
    class var theme11: UIColor? { return UIColor(named: "theme01PointColor01") }
    class var theme12: UIColor? { return UIColor(named: "theme01PointColor02") }
    class var theme13: UIColor? { return UIColor(named: "theme01PointColor03") }
    
    class var theme21: UIColor? { return UIColor(named: "theme02PointColor01") }
    class var theme22: UIColor? { return UIColor(named: "theme02PointColor02") }
    
    class var theme31: UIColor? { return UIColor(named: "theme03PointColor01") }
    class var theme32: UIColor? { return UIColor(named: "theme03PointColor02") }
    
    class var theme41: UIColor? { return UIColor(named: "theme04PointColor01") }
    class var theme42: UIColor? { return UIColor(named: "theme04PointColor02") }
    
    class var theme51: UIColor? { return UIColor(named: "theme05PointColor01") }
    class var theme52: UIColor? { return UIColor(named: "theme05PointColor02") }
}

