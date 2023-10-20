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
    
//     MARK: - Enum 을 이용한 type지정 메서드 구현
//     함수의 이름으로 정확히 구분하는 것이 좋아서 위의 구분된 함수 사용!
//
//    enum SignType {
//        case signUp
//        case signIn
//    }
//    
//    func trySign(type: SignType, email: String, password: String, completion: @escaping (LoginResult) -> Void) {
//        switch type {
//        case .signIn:
//            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
//                checkError(email: email, authResult: authResult, error: error, completion: completion)
//            }
//        case .signUp:
//            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//                checkError(email: email, authResult: authResult, error: error, completion: completion)
//            }
//        }
//    }
//    
//    func checkError(email: String, authResult: AuthDataResult?, error: Error?, completion: @escaping (LoginResult) -> Void) {
//        var result = LoginResult(isSuccess: true, email: email)
//        if error == nil {
//            completion(result)
//        } else {
//            result.isSuccess = false
//            result.errorMessage = String(describing: error)
//            completion(result)
//        }
//    }
}
