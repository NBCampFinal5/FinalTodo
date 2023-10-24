//
//  LockPasswordChangeViewModel.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/23/23.
//

import Foundation

class LockPasswordChangeViewModel {
    let isUnlock: Observable<Bool> = Observable(false)
    let firstPassword: Observable<String> = Observable("")
}
