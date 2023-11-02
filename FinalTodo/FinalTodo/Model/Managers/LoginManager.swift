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
                CoreDataManager.shared.createUser(newUser: user) {}
                completion(result)
            } else {
                result.isSuccess = false
                result.errorMessage = String(describing: error)
                completion(result)
            }
        }
    }
    
    func trySignIn(email: String, password: String, completion: @escaping (LoginResult) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            var result = LoginResult(isSuccess: true, email: email)
            
            if let error = error {
                result.isSuccess = false
                result.errorMessage = error.localizedDescription
                completion(result)
                return
            }
            
            guard let authResult = authResult else {
                result.isSuccess = false
                result.errorMessage = "사용자 인증 결과가 없습니다."
                completion(result)
                return
            }
            
            FirebaseDBManager.shared.fetchUser { userData, fetchError in
                if let fetchError = fetchError {
                    result.isSuccess = false
                    result.errorMessage = fetchError.localizedDescription
                    print("Error fetching user from Firebase: \(fetchError.localizedDescription)")
                    completion(result)
                    return
                }
                
                if let userData = userData {
                    CoreDataManager.shared.updateUser(targetId: authResult.user.email!, newUser: userData) {
                        print("User data successfully updated in CoreData.")
                        completion(result)
                    }
                } else {
                    let newUser = UserData(
                        id: email,
                        nickName: "",
                        folders: [],
                        memos: [],
                        rewardPoint: 0,
                        rewardName: "",
                        themeColor: ""
                    )
                    CoreDataManager.shared.createUser(newUser: newUser) {
                        print("User data successfully created in CoreData.")
                        completion(result)
                    }
                }
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
                print("fail Email")
            }
        }
    }
}
