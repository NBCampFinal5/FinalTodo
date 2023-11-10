//
//  SignUpPageViewModel.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/31/23.
//

enum EmailValidationResult {
    case empty
    case checking
    case available
    case alreadyInUse
    case unavailableFormat
}

enum NickNameValidationResult {
    case empty
    case length
    case available
}

enum PasswordValidationResult {
    case empty
    case length
    case combination
    case special
    case available
}

enum CheckPasswordValidationResult {
    case empty
    case available
    case unconformity
}

import Foundation

class SignUpPageViewModel {
    
    let loginManager = LoginManager()
    
    let email: Observable<String> = Observable("")
    let emailState: Observable<EmailValidationResult> = Observable(.empty)
    
    let nickName: Observable<String> = Observable("")
    let nickNameState: Observable<NickNameValidationResult> = Observable(.empty)
    
    let password: Observable<String> = Observable("")
    let passwordState: Observable<PasswordValidationResult> = Observable(.empty)
    
    let checkPassword: Observable<String> = Observable("")
    let checkPasswordState: Observable<CheckPasswordValidationResult> = Observable(.empty)
    
    let isPrivacyAgree: Observable<Bool> = Observable(false)
    let isSignUpAble: Observable<Bool> = Observable(false)
    
}

extension SignUpPageViewModel {
    // MARK: - 유효성 검사
    func isValidEmail(email: String) {
        if email.count == 0 {
            emailState.value = .empty
            return
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            emailState.value = .checking
            loginManager.isAvailableEmail(email: email) { [weak self] state in
                if state {
                    self?.emailState.value = .available
                } else{
                    self?.emailState.value = .alreadyInUse
                }
            }
        } else {
            emailState.value = .unavailableFormat
        }
    }
    
    func isValidNickName(nickName: String) {
        if nickName.count == 0 {
            nickNameState.value = .empty
            return
        }
        if (2 ... 8).contains(nickName.count) {
            nickNameState.value = .available
        } else {
            nickNameState.value = .length
        }
    }
    
    func isValidPassword(password: String) {
        if password.count == 0 {
            passwordState.value = .empty
            return
        }
        let lengthreg = ".{8,20}"
        let lengthtesting = NSPredicate(format: "SELF MATCHES %@", lengthreg)
        if lengthtesting.evaluate(with: password) == false {
            passwordState.value = .length
            return
        }
        let combinationreg = "^(?=.*[A-Za-z])(?=.*[0-9]).{8,20}"
        let combinationtesting = NSPredicate(format: "SELF MATCHES %@", combinationreg)
        if combinationtesting.evaluate(with: password) == false {
            passwordState.value = .combination
            return
        }
        let specialreg = "^(?=.*[!@#$%^&*()_+=-]).{8,20}"
        let specialtesting = NSPredicate(format: "SELF MATCHES %@", specialreg)
        if specialtesting.evaluate(with: password) == false {
            passwordState.value = .special
            return
        }
        passwordState.value = .available
    }
    
    func isCheckPassword(password: String) {
        if password.count == 0 {
            checkPasswordState.value = .empty
            return
        }
        if checkPassword.value == self.password.value {
            checkPasswordState.value = .available
        } else {
            checkPasswordState.value = .unconformity
        }
    }
    
    func isPossibleSingUp() {
        if emailState.value == .available && nickNameState.value == .available && passwordState.value == .available &&
            checkPasswordState.value == .available && isPrivacyAgree.value == true {
            isSignUpAble.value = true
        } else {
            isSignUpAble.value = false
        }
    }
}
