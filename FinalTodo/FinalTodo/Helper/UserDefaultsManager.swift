//
//  UserDefaultsManager.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/22/23.
//

import Foundation

struct UserDefaultsManager {
    
    let defaults = UserDefaults.standard
    
    let isLock = "isLock"
    let isPassword = "isPassword"
    
    func setLockIsOn(toggle:Bool) {
        defaults.set(toggle, forKey: isLock)
    }
    
    func getLockIsOn() -> Bool {
        return defaults.bool(forKey: isLock)
    }
    
    func setPassword(password: String) {
        defaults.set(password, forKey: isPassword)
    }
    
    func getPassword() -> String {
        guard let password = defaults.string(forKey: isPassword) else { return "" }
        return password
    }
    
}
