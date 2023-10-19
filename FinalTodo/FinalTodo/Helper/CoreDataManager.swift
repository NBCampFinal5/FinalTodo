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

//    private let userEntityName: String = "UsersModel"
//    private let memoEntityName: String = "MemosModel"
//    private let folderEntityName: String = "FoldersModel"

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

    func createUser(id: String, nickName: String, rewardPoint: Int64, themeColor: Int64, completion: @escaping (UsersModel?) -> Void) {
        context?.perform {
            let newUser = UsersModel(context: self.context!)
            newUser.id = id
            newUser.nickName = nickName
            newUser.rewardPoint = rewardPoint
            newUser.themeColor = themeColor

            self.saveContext()
            completion(newUser)
        }
    }

    func fetchUser(byID id: String, completion: @escaping (UsersModel?) -> Void) {
        context?.perform {
            let fetchRequest: NSFetchRequest<UsersModel> = UsersModel.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)

            do {
                let users = try self.context?.fetch(fetchRequest)
                completion(users?.first)
            } catch {
                completion(nil)
            }
        }
    }

    func updateUser(user: UsersModel, nickName: String, rewardPoint: Int64, themeColor: Int64, completion: @escaping (UsersModel?) -> Void) {
        context?.perform {
            user.nickName = nickName
            user.rewardPoint = rewardPoint
            user.themeColor = themeColor

            self.saveContext()
            completion(user)
        }
    }

    func deleteUser(user: UsersModel, completion: @escaping (Bool) -> Void) {
        context?.perform {
            self.context?.delete(user)
            self.saveContext()
            completion(true)
        }
    }

    // MARK: - Folder CRUD

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

    func updateFolder(folder: FoldersModel, title: String, color: Int64, completion: @escaping (FoldersModel?) -> Void) {
        context?.perform {
            folder.title = title
            folder.color = color

            self.saveContext()
            completion(folder)
        }
    }

    func deleteFolder(folder: FoldersModel, completion: @escaping (Bool) -> Void) {
        context?.perform {
            self.context?.delete(folder)
            self.saveContext()
            completion(true)
        }
    }

    // MARK: - Memo CRUD

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

    func deleteMemo(memo: MemosModel, completion: @escaping (Bool) -> Void) {
        context?.perform {
            self.context?.delete(memo)
            self.saveContext()
            completion(true)
        }
    }
}
