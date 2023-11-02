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
    
    func trySignUp(email:String, password: String, nickName: String, completion: @escaping (LoginResult) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            var result = LoginResult(isSuccess: true, email: email)
            if error == nil {
                let user = UserData(
                    id: email,
                    nickName: nickName,
                    folders: [],
                    memos: [],
                    rewardPoint: 0,
                    rewardName: "",
                    themeColor: "error"
                )
                FirebaseDBManager.shared.createUser(user: user) { error in
                    if error == nil {
                        print("@@@ create Fail")
                    } else {
                        print("@@@ create")
                    }
                }
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
    
    func isAvailableEmail(email: String, completion: @escaping (Bool) -> Void){
        
        let db = Firestore.firestore()
        let users = "users"
        
        
        db.collection(users).getDocuments { data, error in
            if error != nil {
                print("[FirebaseManager][\(#function)]: \(String(describing: error?.localizedDescription))")
            } else {
                guard let safeData = data else { return }
                if safeData.documents.map({$0.documentID}).contains(email) {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
    func passwordFind(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error == nil {
                print("send Email")
            } else {
                print("Email sending failed.")
            }
        }
    }
    
    func isLogin() -> Bool{
        if Auth.auth().currentUser != nil {
            if let user = Auth.auth().currentUser {
                print("@@@LoginEmail:",user.email)
            }
            return true
        } else {
            return false
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}
