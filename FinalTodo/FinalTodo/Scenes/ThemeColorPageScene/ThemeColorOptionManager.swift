//
//  ThemeColorOptionManager.swift
//  FinalTodo
//
//  Created by SR on 2023/10/15.
//

import UIKit

class ThemeColorOptionManager {
    var themeColorOptions: [ThemeColorOption] = []

    func makeThemeColorOptions() {
        themeColorOptions =
            [
                ThemeColorOption(Color01: UIColor(red: 26.0/255.0, green: 93.0/255.0, blue: 26.0/255.0, alpha: 1.0),
                                 Color02: UIColor(red: 241.0/255.0, green: 201.0/255.0, blue: 59.0/255.0, alpha: 1.0),
                                 Color03: UIColor(red: 250.0/255.0, green: 227.0/255.0, blue: 146.0/255.0, alpha: 1.0),
                                 title: "기본 컬러"),
                ThemeColorOption(Color01: UIColor(red: 150.0/255.0, green: 181.0/255.0, blue: 197.0/255.0, alpha: 1.0),
                                 Color02: UIColor(red: 173.0/255.0, green: 196.0/255.0, blue: 206.0/255.0, alpha: 1.0),
                                 Color03: UIColor(red: 238.0/255.0, green: 224.0/255.0, blue: 201.0/255.0, alpha: 1.0),
                                 title: "테마 컬러 01"),
                ThemeColorOption(Color01: UIColor(red: 255.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0),
                                 Color02: UIColor(red: 255.0/255.0, green: 99.0/255.0, blue: 99.0/255.0, alpha: 0.48),
                                 Color03: UIColor(red: 255.0/255.0, green: 111.0/255.0, blue: 111.0/255.0, alpha: 0.12),
                                 title: "테마 컬러 02"),
                ThemeColorOption(Color01: UIColor(red: 64.0/255.0, green: 91.0/255.0, blue: 43.0/255.0, alpha: 1.0),
                                 Color02: UIColor(red: 254.0/255.0, green: 252.0/255.0, blue: 234.0/255.0, alpha: 1.0),
                                 Color03: UIColor(red: 223.0/255.0, green: 234.0/255.0, blue: 199.0/255.0, alpha: 1.0),
                                 title: "테마 컬러 03"),
                ThemeColorOption(Color01: UIColor(red: 150.0/255.0, green: 126.0/255.0, blue: 118.0/255.0, alpha: 1.0),
                                 Color02: UIColor(red: 215.0/255.0, green: 192.0/255.0, blue: 174.0/255.0, alpha: 1.0),
                                 Color03: UIColor(red: 238.0/255.0, green: 227.0/255.0, blue: 203.0/255.0, alpha: 1.0),
                                 title: "테마 컬러 04")
            ]
    }

    func getThemeColorOptions() -> [ThemeColorOption] {
        return themeColorOptions
    }
}
