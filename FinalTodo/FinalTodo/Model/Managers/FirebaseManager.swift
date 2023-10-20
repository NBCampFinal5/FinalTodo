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

struct FirebaseManager {
    // TODO: - CRUD 
    let db = Firestore.firestore()
    let users = "Users"
    
    func updateUserData(email: String, completion: @escaping () -> Void) {
        
//        let userData = Users(
//            id: email,
//            nickName: "testNick2",
//            folders: [Folders(id: "hihi", name: "hihi", color: "yellow")], 
//            memoDatas: [
//                Memos(Fileid: "test1", title: "test1", date: "tset1", content: "test1", isPin: false, locationNotifySetting: "test1", timeNotifySetting: "test1"),
//                Memos(Fileid: "test", title: "test", date: "tset", content: "test", isPin: false, locationNotifySetting: "test", timeNotifySetting: "test")
//            ],
//            rewardPoint: 0,
//            settingValue: SettingValues(color: "yellow", font: "testFont")
//        )
        let userData = User(id: "test", nickName: "tset", folders: [], memos: [], rewardPoint: 0, themeColor: 0)
        
        do {
            let data = try Firestore.Encoder().encode(userData)
            db.collection(users).document(email).setData(data)
        } catch {
            print("[FirebaseManager][\(#function)]:Fail")
        }
    }
    
    func fetchUserData(email: String, completion: @escaping (User) -> Void) {
        db.collection(users).document(email).getDocument { data, error in
            if error != nil {
                print("[FirebaseManager][\(#function)]: \(String(describing: error?.localizedDescription))")
            } else {
                guard let data = data?.data() else { return }
                do {
                    var safeData = try Firestore.Decoder().decode(User.self, from: data)
                    completion(safeData)
                } catch {
                    print("[FirebaseManager][\(#function)]: DecodingFail")
                }
            }
        }
    }
}
