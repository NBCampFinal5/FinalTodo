//
//  LoginManager.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/17/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


struct LoginResult {
    var isSuccess: Bool
    let email: String
    var errorMessage: String?
}


struct LoginManager {
    
    func trySignUp(email:String, password: String, completion: @escaping (LoginResult) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            var result = LoginResult(isSuccess: true, email: email)
            if error == nil {
                completion(result)
            } else {
                result.isSuccess = false
                result.errorMessage = String(describing: error)
                completion(result)
            }
        }
    }
    
    func trySignIn(email:String, password: String, completion: @escaping (LoginResult) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
            var result = LoginResult(isSuccess: true, email: email)
            if error == nil {
                completion(result)
            } else {
                result.isSuccess = false
                result.errorMessage = String(describing: error)
                completion(result)
            }
        }
    }
    
    func test(email: String) -> Bool {
        return Auth.auth().isSignIn(withEmailLink: email)
    }
}
