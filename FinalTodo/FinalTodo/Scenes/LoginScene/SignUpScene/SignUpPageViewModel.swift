//
//  SignUpPageViewModel.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/31/23.
//

import Foundation

class SignUpPageViewModel {
    
    let loginManager = LoginManager()
    
    let email:Observable<String> = Observable("")
    let nickName:Observable<String> = Observable("")
    let password:Observable<String> = Observable("")
    let checkPassword:Observable<String> = Observable("")
    
}
