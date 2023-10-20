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
    private init() {} // 싱글톤패턴(static let 인스턴스 + private init())으로 CoreDataManager 유일한 인스턴스 shared 생성 -> 프로젝트 전역에서 접근 가능!

    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context = appDelegate?.persistentContainer.viewContext // AppDelegate에 만들어 놓은 코어데이터스택의 context(임시저장소)에 접근

    // MARK: - Helper Methods

    // context(임시저장소)에서 발생한 변경사항을 영구저장소로 저장하는 메서드
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

    // 비동기처리 -> 방법이 다양한데, 가장 간단하게 코어데이터에서 자체 제공하는 perform 메서드의 코드블록 안에 구현
    // 컴플리션핸들러: 비동기 작업 완료 후 호출되는 클로저(콜백 함수). 비동기 작업의 결과를 전달하거나 다른 작업 실행
    // @escaping 키워드: 클로저가 함수를 벗어난 후에도 호출될 수 있음을 나타냄
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

    // NSFetchRequest: 코어데이터에서 데이터 검색하고 가져오는 클래스
    // NSPredicate: NSFetchRequest에서 필터링 조건 정의, 예시 NSPredicate(format: "age > 25")
    // %@: Core Data에서 Predicate에서 값 대체하는 표시
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

    func updateUser(user: UsersModel, nickName: String, rewardPoint: Int64, themeColor: Int64, completion: @escaping (UsersModel?) -> Void) {
        if let context = context {
            context.perform {
                user.nickName = nickName
                user.rewardPoint = rewardPoint
                user.themeColor = themeColor

                self.saveContext()
                completion(user)
            }
        } else {
            print("Context is nil, failed to update user.")
            completion(nil)
        }
    }

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
    func createFolder(id: String, title: String, color: Int64, completion: @escaping (FoldersModel?) -> Void) {
        context?.perform {
            let newFolder = FoldersModel(context: self.context!)
            newFolder.id = id
            newFolder.title = title
            newFolder.color = color

            self.saveContext()
            completion(newFolder)
        }
    }

    // 모든 폴더 가져오기
    func fetchAllFolders(completion: @escaping ([FoldersModel]?) -> Void) {
        context?.perform {
            let fetchRequest: NSFetchRequest<FoldersModel> = FoldersModel.fetchRequest()

            do {
                let folders = try self.context?.fetch(fetchRequest)
                completion(folders)
            } catch {
                completion(nil)
            }
        }
    }

    // 폴더 아이디로 필터링해서 가져오기
    func fetchFolder(byID id: String, completion: @escaping (FoldersModel?) -> Void) {
        context?.perform {
            let fetchRequest: NSFetchRequest<FoldersModel> = FoldersModel.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)

            do {
                let folders = try self.context?.fetch(fetchRequest)
                completion(folders?.first)
            } catch {
                completion(nil)
            }
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

    // 폴더 삭제
    func deleteFolder(folder: FoldersModel, completion: @escaping (Bool) -> Void) {
        context?.perform {
            self.context?.delete(folder)
            self.saveContext()
            completion(true)
        }
    }

    // MARK: - Memo CRUD

    // 새 메모 생성
    func createMemo(title: String, date: String, content: String, isPin: Bool, fileId: String, locationNotifySetting: String?, timeNotifySetting: String?, completion: @escaping (MemosModel?) -> Void) {
        context?.perform {
            let newMemo = MemosModel(context: self.context!)
            newMemo.title = title
            newMemo.date = date
            newMemo.content = content
            newMemo.isPin = isPin
            newMemo.fileId = fileId
            newMemo.locationNotifySetting = locationNotifySetting
            newMemo.timeNotifySetting = timeNotifySetting

            self.saveContext()
            completion(newMemo)
        }
    }

    // 파일id로 필터링한 메모 불러오기
    func fetchMemo(byFileId FileId: String, completion: @escaping ([MemosModel]?) -> Void) {
        context?.perform {
            let fetchRequest: NSFetchRequest<MemosModel> = MemosModel.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "fileId == %@", FileId)

            do {
                let memos = try self.context?.fetch(fetchRequest)
                completion(memos)
            } catch {
                completion(nil)
            }
        }
    }

    // 메모 수정
    func updateMemo(memo: MemosModel, title: String, date: String, content: String, isPin: Bool, fileId: String, locationNotifySetting: String?, timeNotifySetting: String?, completion: @escaping (MemosModel?) -> Void) {
        context?.perform {
            memo.title = title
            memo.date = date
            memo.content = content
            memo.isPin = isPin
            memo.fileId = fileId
            memo.locationNotifySetting = locationNotifySetting
            memo.timeNotifySetting = timeNotifySetting

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
}

// ::사용 방법::
// CoreDataManager.shared 코드를 통해 메서드 호출, 컴플리션핸들러 부분에 클로저로 작성되는 코드는 작업 완료 후 수행할 다른 작업 구현하면 됩니다!
