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
            
            guard authResult != nil else {
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
                
                CoreDataManager.shared.deleteAllData() {
                    // 모든 사용자 데이터 삭제 후, 파이어베이스 데이터로 업데이트 진행
                    if let userData = userData {
                        // Firebase에서 가져온 데이터로 코어 데이터 업데이트
                        CoreDataManager.shared.createUser(newUser: userData) {
                            print("User data successfully updated in CoreData.")
                            CoreDataManager.shared.fetchFolder() {
                                CoreDataManager.shared.fetchMemo() {
                                    let folders = CoreDataManager.shared.getFolders()
                                    let memos = CoreDataManager.shared.getMemos()
                                    print(folders)
                                    print(memos)
                                    completion(result)
                                }
                            }
                        }
                    } else {
                        // 파이어베이스에서 유저 데이터를 가져올 수 없는 경우, 새 유저 데이터 생성
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
        
        let userDefaultManager = UserDefaultsManager()
        let notifySettingManager = NotifySettingManager.shared
        
        do {
            print(Auth.auth().currentUser?.email,"SignOut")
            userDefaultManager.setPassword(password: "")
            userDefaultManager.setLockIsOn(toggle: false)
            userDefaultManager.setAutoLogin(toggle: false)
            notifySettingManager.isNotificationEnabled = false
            notifySettingManager.isSoundEnabled = false
            notifySettingManager.isVibrationEnabled = false
            
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}
