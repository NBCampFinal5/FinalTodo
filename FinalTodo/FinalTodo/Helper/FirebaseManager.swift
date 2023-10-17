//
//  FirebaseManager.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/17/23.
//
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseDatabase


struct UserData: Codable {
    var email: String
    var rewardPoint: Int
}

struct FirebaseManager {
    
    let db = Firestore.firestore()
    let ref = Database.database().reference()
    let user = "Users"
    
    func creatUserData(email: String, completion: @escaping () -> Void) {
        
        let userData = UserData(email: email, rewardPoint: 0)
        
        do {
            let data = try Firestore.Encoder().encode(userData)
            db.collection(user).document(email).setData(data)
        } catch {
            print("@@@ Fail")
        }
        
    }
}
