//
//  FirebaseDBManager.swift
//  FinalTodo
//
//  Created by Jongbum Lee on 2023/10/26.
//

import Foundation
import FirebaseFirestore

class FirebaseDBManager {
    
    static let shared = FirebaseDBManager()
    private let db = Firestore.firestore()
    
    private init() { }
    
    func createUser(user: UserData, completion: @escaping (Error?) -> Void) {
        saveUser(user: user, isUpdate: false, completion: completion)
    }
    
    func updateUser(user: UserData, completion: @escaping (Error?) -> Void) {
        saveUser(user: user, isUpdate: true, completion: completion)
    }
    
    func fetchUser(userId: String, completion: @escaping (UserData?, Error?) -> Void) {
        db.collection("users").document(userId).getDocument { document, error in
            guard let data = document?.data(), let user = UserData(fromDictionary: data) else {
                completion(nil, error)
                return
            }
            completion(user, nil)
        }
    }
    
    func deleteUser(userId: String, completion: @escaping (Error?) -> Void) {
        db.collection("users").document(userId).delete() { error in
            completion(error)
        }
    }
    
    func saveUser(user: UserData, isUpdate: Bool, completion: @escaping (Error?) -> Void) {
        guard let documentData = try? user.asDictionary() else {
            completion(NSError(domain: "", code: -1, userInfo: nil))
            return
        }
        let userRef = db.collection("users").document(user.id)
        if isUpdate {
            userRef.updateData(documentData, completion: completion)
        } else {
            userRef.setData(documentData, completion: completion)
        }
    }
    
    func fetchData<T: Decodable>(for user: UserData, collection: String, completion: @escaping ([T]?, Error?) -> Void) {
        db.collection("users").document(user.id).collection(collection).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                completion(nil, error)
                return
            }
            let items = documents.compactMap { T(fromDictionary: $0.data()) }
            completion(items, nil)
        }
    }
    
    func fetchFolders(of user: UserData, completion: @escaping ([FolderData]?, Error?) -> Void) {
        fetchData(for: user, collection: "folders", completion: completion)
    }
    
    func fetchMemos(of user: UserData, completion: @escaping ([MemoData]?, Error?) -> Void) {
        fetchData(for: user, collection: "memos", completion: completion)
    }
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}

extension Decodable {
    init?(fromDictionary dictionary: [String: Any]) {
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            self = try JSONDecoder().decode(Self.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
}
