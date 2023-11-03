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
        var coreDataUser = CoreDataManager.shared.fetchUser()
        
        print("CoreData User ID: \(coreDataUser .id)")
        // ID 유효성 검사
        if coreDataUser.id.isEmpty || coreDataUser.id == "error" {
            
            completion(FirestoreError.invalidUserData.asNSError())
            return
        }
        
        do {
            let userDictionary = try coreDataUser.asDictionary()
            
            // 현재 사용자 ID와 Core Data의 사용자 ID가 일치하는지 검사
            guard let userId = self.currentUserId, userId == coreDataUser.id else {
                let currentUserIdString = self.currentUserId ?? "nil"
                let coreUserIdString = coreDataUser.id
                print("currentUserId: \(currentUserIdString), coreDataUser.id: \(coreUserIdString)")
                completion(FirestoreError.userIdMismatch.asNSError())
                return
            }
            
            // Firebase 데이터 업데이트
            self.db.collection("users").document(userId).setData(userDictionary) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    
    func fetchUserFromFirebase(completion: @escaping (UserData) -> Void) {
        FirebaseDBManager.shared.fetchUser { userData, error in
            if let userData = userData {
                // Core Data에 사용자 데이터 저장
                CoreDataManager.shared.createUser(newUser: userData) {
                    completion(userData)
                    let printAll = PrintDetails()
                    printAll.show(of: userData)
                }
                
            } else if let error = error {
                print("Firebase 데이터 가져오기 실패:", error)
            }
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
            print("사용자 ID를 찾을 수 없습니다.")
            completion(nil, FirestoreError.noUserFound.asNSError())
            return
        }
        
        print("폴더 데이터를 가져오기 시작합니다. 사용자 ID: \(userId)")
        db.collection("users").document(userId).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("사용자 데이터를 가져오는 데 실패했습니다: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let document = documentSnapshot, document.exists else {
                print("해당 사용자의 문서를 찾을 수 없습니다.")
                completion(nil, error)
                return
            }
            
            guard let folderDataArray = document.data()?["folders"] as? [[String: Any]] else {
                print("folders 필드를 찾을 수 없거나, 올바른 형식이 아닙니다.")
                completion(nil, error)
                return
            }
            
            if folderDataArray.isEmpty {
                print("folders 필드가 비어 있습니다. 폴더가 없는 것 같습니다.")
            } else {
                print("폴더 데이터가 성공적으로 가져와졌습니다. 폴더 수: \(folderDataArray.count)")
            }
            
            let folders = folderDataArray.compactMap { FolderData(fromDictionary: $0) }
            print("가져온 폴더 데이터: \(folders)")
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
            print("사용자 ID를 찾을 수 없습니다.")
            completion(nil, FirestoreError.noUserFound.asNSError())
            return
        }
        
        print("메모 데이터를 가져오기 시작합니다. 사용자 ID: \(userId)")
        db.collection("users").document(userId).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("사용자 데이터를 가져오는 데 실패했습니다: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let document = documentSnapshot, document.exists else {
                print("해당 사용자의 문서를 찾을 수 없습니다.")
                completion(nil, error)
                return
            }
            
            guard let memoDataArray = document.data()?["memos"] as? [[String: Any]] else {
                print("memos 필드를 찾을 수 없거나, 올바른 형식이 아닙니다.")
                completion(nil, error)
                return
            }
            
            if memoDataArray.isEmpty {
                print("memos 필드가 비어 있습니다. 메모가 없는 것 같습니다.")
            } else {
                print("메모 데이터가 성공적으로 가져와졌습니다. 메모 수: \(memoDataArray.count)")
            }
            
            let memos = memoDataArray.compactMap { MemoData(fromDictionary: $0) }
            print("가져온 메모 데이터: \(memos)")
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
