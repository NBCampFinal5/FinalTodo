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
    
    func setLockIsOn(toggle:Bool) {
        defaults.set(toggle, forKey: isLock)
    }
    
    func getLockIsOn() -> Bool{
        return defaults.bool(forKey: isLock)
    }
    
}
