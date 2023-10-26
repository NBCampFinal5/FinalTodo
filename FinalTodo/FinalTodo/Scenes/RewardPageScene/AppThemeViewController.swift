//
//  AppThemeViewController.swift
//  FinalTodo
//
//  Created by t2023-m0087 on 10/25/23.
//

import UIKit

class AppThemeViewController: UIViewController {
    // ...

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // 현재 테마에 따라 UI를 업데이트하는 메서드
    func updateUIForCurrentTheme() {
        let theme = ThemeManager.currentTheme

        switch theme {
        case .theme1:
            func changeCustomTheme() {
                CustomTheme.firstColor = .theme11
                CustomTheme.secondColor = .theme13
            }

        case .theme2:
            func changeCustomTheme() {
                CustomTheme.firstColor = .theme21
                CustomTheme.secondColor = .theme22
            }
        case .theme3:
            func changeCustomTheme() {
                CustomTheme.firstColor = .theme31
                CustomTheme.secondColor = .theme32
            }
        case .theme4:
            func changeCustomTheme() {
                CustomTheme.firstColor = .theme41
                CustomTheme.secondColor = .theme42
            }
        case .theme5:
            func changeCustomTheme() {
                CustomTheme.firstColor = .theme51
                CustomTheme.secondColor = .theme52
            }
        }
    }
}

