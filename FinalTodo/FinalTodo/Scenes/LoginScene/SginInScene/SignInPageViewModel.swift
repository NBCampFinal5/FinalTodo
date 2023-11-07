//
//  SignInPageViewModel.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/30/23.
//

import Foundation

class SignInPageViewModel {
    let userDefaultManager = UserDefaultsManager()
    let loginManager = LoginManager()
    let email: Observable<String> = Observable("")
    let password: Observable<String> = Observable("")
}
