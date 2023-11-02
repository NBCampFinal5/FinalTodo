//
//  FirebaseDBManager.swift
//  FinalTodo
//
//  Created by Jongbum Lee on 2023/10/26.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class FirebaseDBManager {
    
    static let shared = FirebaseDBManager()
    private let db = Firestore.firestore()
    
    private enum FirestoreError: Int {
        case noUserFound = 1
        case userIdMismatch = 2
        case dataConversionError = 3
        case invalidUserData = 4
        
        var localizedDescription: String {
            switch self {
            case .noUserFound: return "로그인된 사용자를 찾을 수 없습니다."
            case .userIdMismatch: return "사용자 ID가 일치하지 않습니다."
            case .dataConversionError: return "데이터 변환 에러"
            case .invalidUserData: return "사용 불가 유저 데이터"
            }
        }
        
        func asNSError() -> NSError {
            return NSError(domain: "FirebaseDBManager", code: rawValue, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
        }
    }
    
    var currentUserId: String? {
        return Auth.auth().currentUser?.email
    }
    
    private init() { }
}

// MARK: - Coredata-Firebase Fetch
extension FirebaseDBManager {
    func updateFirebaseWithCoredata(completion: @escaping (Error?) -> Void) {
        var coreDataUser = CoreDataManager.shared.getUser()
        
        if coreDataUser.id.isEmpty {
            completion(FirestoreError.invalidUserData.asNSError())
            return
        }
        
        do {
            let userDictionary = try coreDataUser.asDictionary()
            
            guard let userId = currentUserId, userId == coreDataUser.id else {
                let currentUserIdString = currentUserId ?? "nil"
                let coreUserIdString = coreDataUser.id
                print("currentUserId: \(currentUserIdString), coreDataUser.id: \(coreUserIdString)")
                completion(FirestoreError.userIdMismatch.asNSError())
                return
            }
            
            self.db.collection("users").document(userId).setData(userDictionary) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
}

// MARK: - UserData Operations
extension FirebaseDBManager {
    
    func createUser(user: UserData, completion: @escaping (Error?) -> Void) {
        guard let userId = currentUserId, user.id == userId else {
            completion(FirestoreError.userIdMismatch.asNSError())
            return
        }
        guard let documentData = try? user.asDictionary() else {
            completion(FirestoreError.dataConversionError.asNSError())
            return
        }
        db.collection("users").document(userId).setData(documentData, completion: completion)
    }
    
    func updateUser(user: UserData, completion: @escaping (Error?) -> Void) {
        guard let userId = currentUserId, user.id == userId else {
            completion(FirestoreError.userIdMismatch.asNSError())
            return
        }
        guard let documentData = try? user.asDictionary() else {
            completion(FirestoreError.dataConversionError.asNSError())
            return
        }
        db.collection("users").document(userId).updateData(documentData, completion: completion)
    }
    
    func deleteUser(completion: @escaping (Error?) -> Void) {
        guard let userId = currentUserId else {
            completion(FirestoreError.noUserFound.asNSError())
            return
        }
        db.collection("users").document(userId).delete(completion: completion)
    }
    
    func fetchUser(completion: @escaping (UserData?, Error?) -> Void) {
        guard let userId = currentUserId else {
            completion(nil, FirestoreError.noUserFound.asNSError())
            return
        }
        db.collection("users").document(userId).getDocument { document, error in
            guard let data = document?.data(), let user = UserData(fromDictionary: data) else {
                completion(nil, error)
                return
            }
            completion(user, nil)
        }
    }
}

// MARK: - FolderData Operations
extension FirebaseDBManager {
    
    func createFolder(folder: FolderData, completion: @escaping (Error?) -> Void) {
        guard let userId = currentUserId else {
            completion(FirestoreError.noUserFound.asNSError())
            return
        }
        guard let documentData = try? folder.asDictionary() else {
            completion(FirestoreError.dataConversionError.asNSError())
            return
        }
        db.collection("users").document(userId).collection("folders").document(folder.id).setData(documentData, completion: completion)
    }
    
    func updateFolder(folder: FolderData, completion: @escaping (Error?) -> Void) {
        guard let userId = currentUserId else {
            completion(FirestoreError.noUserFound.asNSError())
            return
        }
        guard let documentData = try? folder.asDictionary() else {
            completion(FirestoreError.dataConversionError.asNSError())
            return
        }
        db.collection("users").document(userId).collection("folders").document(folder.id).updateData(documentData, completion: completion)
    }
    
    func deleteFolder(folderId: String, completion: @escaping (Error?) -> Void) {
        guard let userId = currentUserId else {
            completion(FirestoreError.noUserFound.asNSError())
            return
        }
        db.collection("users").document(userId).collection("folders").document(folderId).delete(completion: completion)
    }
    
    func fetchFolderData(completion: @escaping ([FolderData]?, Error?) -> Void) {
        guard let userId = currentUserId else {
            completion(nil, FirestoreError.noUserFound.asNSError())
            return
        }
        db.collection("users").document(userId).collection("folders").getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                completion(nil, error)
                return
            }
            let folders = documents.compactMap { FolderData(fromDictionary: $0.data()) }
            completion(folders, nil)
        }
    }
}

// MARK: - MemoData Operations
extension FirebaseDBManager {
    
    func createMemo(memo: MemoData, completion: @escaping (Error?) -> Void) {
        guard let userId = currentUserId else {
            completion(FirestoreError.noUserFound.asNSError())
            return
        }
        guard let documentData = try? memo.asDictionary() else {
            completion(FirestoreError.dataConversionError.asNSError())
            return
        }
        db.collection("users").document(userId).collection("memos").document(memo.id).setData(documentData, completion: completion)
    }
    
    func updateMemo(memo: MemoData, completion: @escaping (Error?) -> Void) {
        guard let userId = currentUserId else {
            completion(FirestoreError.noUserFound.asNSError())
            return
        }
        guard let documentData = try? memo.asDictionary() else {
            completion(FirestoreError.dataConversionError.asNSError())
            return
        }
        db.collection("users").document(userId).collection("memos").document(memo.id).updateData(documentData, completion: completion)
        
    }
    
    func deleteMemo(memoId: String, completion: @escaping (Error?) -> Void) {
        guard let userId = currentUserId else {
            completion(FirestoreError.noUserFound.asNSError())
            return
        }
        db.collection("users").document(userId).collection("memos").document(memoId).delete(completion: completion)
    }
    
    func fetchMemos(completion: @escaping ([MemoData]?, Error?) -> Void) {
        guard let userId = currentUserId else {
            completion(nil, FirestoreError.noUserFound.asNSError())
            return
        }
        db.collection("users").document(userId).collection("memos").getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                completion(nil, error)
                return
            }
            let memos = documents.compactMap { MemoData(fromDictionary: $0.data()) }
            completion(memos, nil)
        }
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
