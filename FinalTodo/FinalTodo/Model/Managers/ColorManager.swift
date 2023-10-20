import UIKit

struct ColorManager {
    static let themeArray: [ColorTheme] = [
        ColorTheme(
            backgroundColor: UIColor(named: "theme01PointColor02"),
            pointColor01: UIColor(named: "theme01PointColor01"),
            pointColor02: UIColor(named: "theme01PointColor03")
        )
    ]
}

struct ColorTheme {
    var backgroundColor: UIColor?
    var pointColor01: UIColor?
    var pointColor02: UIColor?
}
