//
//  LockSettingViewModel.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/22/23.
//

import Foundation

class LockSettingViewModel {
    
    let userDefaultManager = UserDefaultsManager()
    
    lazy var isLock: Observable<Bool> = Observable(userDefaultManager.getLockIsOn())
    
    let cellDatas: [SettingOption] = [
        SettingOption(icon: "lock", title: "잠금 설정", showSwitch: true),
        SettingOption(icon: "lock.rotation", title: "비밀번호 변경", showSwitch: false),
    ]
    
}
