//
//  AppInfoViewModel.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/31/23.
//

import Foundation

class AppInfoViewModel {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    let developer = "김서진 zzin2990@gmail.com \n이종범 mate6365@gmail.com \n원성준 tjdwns575859@gmail.com \n오서령 osrsla@gmail.com \n서준영 ghddns34@gmail.com"
}
