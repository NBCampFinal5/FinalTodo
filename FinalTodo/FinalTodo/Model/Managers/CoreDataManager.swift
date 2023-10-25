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

    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    lazy var context = appDelegate?.persistentContainer.viewContext

    // 엔터티 이름(코어데이터에 저장된 객체)
    let userModelName: String = "UserModel"
    let folderModelName: String = "FolderModel"
    let memoModelName: String = "MemoModel"
}

// CRUD
extension CoreDataManager {
    // MARK: 유저 CRUD

    // 유저 - CREATE
    func saveUserForCoreData(id: String, nickName: String, rewardPoint: Int64, themeColor: Int64, completion: @escaping () -> Void) {
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: userModelName, in: context) {
                if let newUser = NSManagedObject(entity: entity, insertInto: context) as? UserModel {
                    newUser.id = id
                    newUser.nickName = nickName
                    newUser.rewardPoint = rewardPoint
                    newUser.themeColor = themeColor

                    if context.hasChanges {
                        do {
                            try context.save()
                            completion()
                        } catch {
                            print("::코어데이터:: 유저 만들기 실패!")
                            completion()
                        }
                    }
                }
            }
        }

        completion()
    }

    // 유저 - READ
    func getUserListFromCoreData() -> [UserModel] {
        var userList: [UserModel] = []

        if let context = context {
            let request = NSFetchRequest<UserModel>(entityName: userModelName)
            let idOrder = NSSortDescriptor(key: "id", ascending: true)
            request.sortDescriptors = [idOrder]

            do {
                userList = try context.fetch(request)
            } catch {
                print("::코어데이터:: 유저 가져오기 실패!")
            }
        }
        return userList
    }

    // 유저 - Update
    func updateUserFromCoreData(newUser: UserModel, completion: @escaping () -> Void) {
        if let context = context {
            if context.hasChanges {
                do {
                    try context.save()
                    completion()
                } catch {
                    print("::코어데이터:: 유저 업데이트 실패!")
                    completion()
                }
            }
        }
    }

    // 유저 - Delete
    func deleteUserFromCoreData(data: UserModel, completion: @escaping () -> Void) {
        if let context = context {
            context.delete(data)

            if context.hasChanges {
                do {
                    try context.save()
                    completion()
                } catch {
                    print("::코어데이터:: 유저 삭제 실패!")
                    completion()
                }
            }
        }
    }

    // MARK: 폴더 CRUD

    // 폴더 - CREATE
    func saveFolderForCoreData(id: String, title: String, color: Int64, completion: @escaping () -> Void) {
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: folderModelName, in: context) {
                if let newFolder = NSManagedObject(entity: entity, insertInto: context) as? FolderModel {
                    newFolder.id = id
                    newFolder.title = title
                    newFolder.color = color

                    if context.hasChanges {
                        do {
                            try context.save()
                            completion()
                        } catch {
                            print("::코어데이터:: 폴더 만들기 실패!")
                            completion()
                        }
                    }
                }
            }
        }

        completion()
    }

    // 폴더 - READ
    func getFolderListFromCoreData() -> [FolderModel] {
        var folderList: [FolderModel] = []

        if let context = context {
            let request = NSFetchRequest<FolderModel>(entityName: folderModelName)
            let idOrder = NSSortDescriptor(key: "id", ascending: true)
            request.sortDescriptors = [idOrder]

            do {
                folderList = try context.fetch(request)
            } catch {
                print("::코어데이터:: 폴더 가져오기 실패!")
            }
        }
        return folderList
    }

    // 폴더 - Update
    func updateFolderFromCoreData(newFolder: FolderModel, completion: @escaping () -> Void) {
        if let context = context {
            if context.hasChanges {
                do {
                    try context.save()
                    completion()
                } catch {
                    print("::코어데이터:: 폴더 업데이트 실패!")
                    completion()
                }
            }
        }
    }

    // 폴더 - Delete
    func deleteFolderFromCoreData(data: FolderModel, completion: @escaping () -> Void) {
        if let context = context {
            context.delete(data)

            if context.hasChanges {
                do {
                    try context.save()
                    completion()
                } catch {
                    print("::코어데이터:: 폴더 삭제 실패!")
                    completion()
                }
            }
        }
    }

    // MARK: 메모 CRUD

    // 메모 - CREATE
    func saveMemoForCoreData(folderId: String?, title: String?, content: String?, date: String?, isPin: Bool, locationNotifySetting: String?, timeNotifySetting: String?, completion: @escaping () -> Void) {
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: memoModelName, in: context) {
                if let newMemo = NSManagedObject(entity: entity, insertInto: context) as? MemoModel {
                    newMemo.folderId = folderId
                    newMemo.title = title
                    newMemo.content = content
                    newMemo.date = date
                    newMemo.isPin = isPin
                    newMemo.locationNotifySetting = locationNotifySetting
                    newMemo.timeNotifySetting = timeNotifySetting

                    if context.hasChanges {
                        do {
                            try context.save()
                            completion()
                        } catch {
                            print("::코어데이터:: 메모 만들기 실패!")
                            completion()
                        }
                    }
                }
            }
        }

        completion()
    }

    // 메모 - READ
    func getMemoListFromCoreData() -> [MemoModel] {
        var memoList: [MemoModel] = []

        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: memoModelName)
            let dateOrder = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [dateOrder]

            do {
                if let fetchedMemoList = try context.fetch(request) as? [MemoModel] {
                    memoList = fetchedMemoList
                }

            } catch {
                print("::코어데이터:: 메모 가져오기 실패!")
            }
        }
        return memoList
    }

    // 메모 - Update
    func updateMemoFromCoreData(newMemo: MemoModel, completion: @escaping () -> Void) {
        guard let date = newMemo.date else {
            completion()
            return
        }

        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.memoModelName)
            request.predicate = NSPredicate(format: "date = %@", date as CVarArg)

            do {
                if let fetchedMemo = try context.fetch(request) as? [MemoModel] {
                    if var targetMemo = fetchedMemo.first {
                        // 새로운 메모로 할당
                        targetMemo = newMemo
                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print("::코어데이터:: 메모 삭제 실패! 00")
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                print("::코어데이터:: 메모 삭제 실패! 01")
                completion()
            }
        }
    }

    // 메모 - Delete
    func deleteMemoFromCoreData(data: MemoModel, completion: @escaping () -> Void) {
        guard let date = data.date else {
            completion()
            return
        }

        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.memoModelName)
            request.predicate = NSPredicate(format: "date = %@", date as CVarArg)

            do {
                if let fetchedMemo = try context.fetch(request) as? [MemoModel] {
                    if let targetMemo = fetchedMemo.first {
                        context.delete(targetMemo)

                        if context.hasChanges {
                            do {
                                try context.save()
                                completion()

                            } catch {
                                print("::코어데이터:: 메모 지우기 실패! 00")
                                completion()
                            }
                        }
                    }
                }

            } catch {
                print("::코어데이터:: 메모 지우기 실패! 01")
                completion()
            }
        }
    }
}
