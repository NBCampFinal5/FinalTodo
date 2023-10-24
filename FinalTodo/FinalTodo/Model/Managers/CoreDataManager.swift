//
//  CoreDataManager.swift
//  FinalTodo
//
//  Created by SR on 2023/10/18.
//

import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context = appDelegate?.persistentContainer.viewContext

    // MARK: - Helper Methods

    private func saveContext() {
        do {
            try context?.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}

extension CoreDataManager {
    // MARK: - User CRUD

    // 유저 정보 생성
    func createUser(id: String, nickName: String, rewardPoint: Int64, themeColor: Int64, completion: @escaping (UsersModel?) -> Void) {
        if let context = context {
            context.perform {
                let newUser = UsersModel(context: context)
                newUser.id = id
                newUser.nickName = nickName
                newUser.rewardPoint = rewardPoint
                newUser.themeColor = themeColor

                self.saveContext()
                completion(newUser)
            }
        } else {
            print("Context is nil, failed to create user.")
            completion(nil)
        }
    }

    // 아이디로 유저 정보 가져오기
    func fetchUser(byID id: String, completion: @escaping (UsersModel?) -> Void) {
        if let context = context {
            context.perform {
                let fetchRequest: NSFetchRequest<UsersModel> = UsersModel.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", id)

                do {
                    let users = try context.fetch(fetchRequest)
                    completion(users.first)
                } catch {
                    completion(nil)
                }
            }

        } else {
            print("Context is nil, failed to fetch user.")
            completion(nil)
        }
    }

    // 유저정보 업데이트
    func updateUser(user: UsersModel, newUser: UsersModel, completion: @escaping (UsersModel?) -> Void) {
        context?.perform {
            user.id = newUser.id
            user.nickName = newUser.nickName
            user.rewardPoint = newUser.rewardPoint
            user.themeColor = newUser.themeColor

            self.saveContext()
            completion(user)
        }
    }

    // 해당 유저 삭제
    func deleteUser(user: UsersModel, completion: @escaping (Bool) -> Void) {
        if let context = context {
            context.perform {
                context.delete(user)
                self.saveContext()
                completion(true)
            }
        } else {
            print("Context is nil, failed to delete user.")
            completion(false)
        }
    }

    // MARK: - Folder CRUD

    // 새폴더 생성
    func createFolder(newFolder: FoldersModel, completion: @escaping (FoldersModel?) -> Void) {
        context?.perform {
            let folder = FoldersModel(context: self.context!)
            folder.id = newFolder.id
            folder.title = newFolder.title
            folder.color = newFolder.color

            self.saveContext()
            completion(folder)
        }
    }

    // 유저의 모든 폴더 가져오기
    func fetchFolders(forUser user: UsersModel, completion: @escaping ([FoldersModel]?) -> Void) {
        context?.perform {
            if let userFolders = user.folder?.allObjects as? [FoldersModel] {
                completion(userFolders)
            } else {
                completion(nil)
            }
        }
    }

    // 폴더를 제목 또는 내용 일부 검색
    func searchFolders(keyword: String, completion: @escaping ([FoldersModel]?) -> Void) {
        if let context = context {
            context.perform {
                let fetchRequest: NSFetchRequest<FoldersModel> = FoldersModel.fetchRequest()

                // 검색 키워드를 제목 또는 내용과 비교
                let predicate = NSPredicate(format: "title CONTAINS[c] %@ OR ANY memos.content CONTAINS[c] %@", keyword, keyword)
                fetchRequest.predicate = predicate

                do {
                    let folders = try context.fetch(fetchRequest)
                    completion(folders)
                } catch {
                    completion(nil)
                }
            }
        } else {
            print("Context is nil, failed to search folders.")
            completion(nil)
        }
    }

    // 폴더 수정
    func updateFolder(folder: FoldersModel, title: String, color: Int64, completion: @escaping (FoldersModel?) -> Void) {
        context?.perform {
            folder.title = title
            folder.color = color

            self.saveContext()
            completion(folder)
        }
    }

    // 해당 폴더 삭제
    func deleteFolder(folder: FoldersModel, completion: @escaping (Bool) -> Void) {
        context?.perform {
            self.context?.delete(folder)
            self.saveContext()
            completion(true)
        }
    }

    // MARK: - Memo CRUD

    // 메모 만들기
    func createMemo(memo: MemosModel, completion: @escaping (MemosModel?) -> Void) {
        context?.perform {
            let newMemo = MemosModel(context: self.context!)
            newMemo.title = memo.title
            newMemo.date = memo.date
            newMemo.content = memo.content
            newMemo.isPin = memo.isPin
            newMemo.fileId = memo.fileId
            newMemo.locationNotifySetting = memo.locationNotifySetting
            newMemo.timeNotifySetting = memo.timeNotifySetting

            self.saveContext()
            completion(newMemo)
        }
    }

    // 폴더에 속한 모든 메모 가져오기
    func fetchMemos(forFolder folder: FoldersModel, completion: @escaping ([MemosModel]?) -> Void) {
        context?.perform {
            if let folderMemos = folder.memo?.allObjects as? [MemosModel] {
                completion(folderMemos)
            } else {
                completion(nil)
            }
        }
    }

    // 메모 수정
    func updateMemo(memo: MemosModel, newMemo: MemosModel, completion: @escaping (MemosModel?) -> Void) {
        context?.perform {
            memo.title = newMemo.title
            memo.date = newMemo.date
            memo.content = newMemo.content
            memo.isPin = newMemo.isPin
            memo.fileId = newMemo.fileId
            memo.locationNotifySetting = newMemo.locationNotifySetting
            memo.timeNotifySetting = newMemo.timeNotifySetting

            self.saveContext()
            completion(memo)
        }
    }

    // 메모 삭제
    func deleteMemo(memo: MemosModel, completion: @escaping (Bool) -> Void) {
        context?.perform {
            self.context?.delete(memo)
            self.saveContext()
            completion(true)
        }
    }

    // MARK: - resetCoreData

    // 코어데이터 데이터 초기화
    func resetCoreData() {
        if let context = context {
            context.perform {
                let userFetchRequest: NSFetchRequest<UsersModel> = UsersModel.fetchRequest()
                if let users = try? context.fetch(userFetchRequest) {
                    for user in users {
                        context.delete(user)
                    }
                }

                let folderFetchRequest: NSFetchRequest<FoldersModel> = FoldersModel.fetchRequest()
                if let folders = try? context.fetch(folderFetchRequest) {
                    for folder in folders {
                        context.delete(folder)
                    }
                }

                let memoFetchRequest: NSFetchRequest<MemosModel> = MemosModel.fetchRequest()
                if let memos = try? context.fetch(memoFetchRequest) {
                    for memo in memos {
                        context.delete(memo)
                    }
                }

                self.saveContext()
            }
        }
    }
}

// ::사용 방법::
// CoreDataManager.shared 코드를 통해 메서드 호출, 컴플리션핸들러 부분에 클로저로 작성되는 코드는 작업 완료 후 수행할 다른 작업 구현하면 됩니다!

//    // 이미 존재하는 유저와 폴더를 가져온다고 가정
//    let user = // 유저 모델 가져오기
//    let folder = // 폴더 모델 가져오기
//
//    // 새 메모를 생성
//    let newMemo = MemosModel()
//    newMemo.title = "Sample Memo"
//    newMemo.date = "2023-10-25"
//    newMemo.content = "This is a sample memo."
//    newMemo.isPin = false
//    newMemo.fileId = "dummyFileID"
//    newMemo.locationNotifySetting = "Location Setting"
//    newMemo.timeNotifySetting = "Time Setting"
//
//    // 메모를 특정 유저와 폴더와 연결
//    newMemo.user = user
//    newMemo.folder = folder
//
//    // 메모를 저장
//    coreDataManager.createMemo(memo: newMemo) { createdMemo in
//        if let memo = createdMemo {
//            print("Created Memo: \(memo.title), Date: \(memo.date), Content: \(memo.content)")
//
//            // 메모가 특정 유저와 폴더에 연결되었습니다.
//
//            // 메모 업데이트 또는 삭제 작업 수행
//            // ...
//        } else {
//            print("Failed to create memo.")
//        }
//    }
