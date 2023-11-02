//
//  CoreDataManager.swift
//  FinalTodo
//
//  Created by SR on 2023/10/18.
//

// class를 쓰는 이유? struct? -> class
// 메서드 파라미터와 리턴값 변경
// 싱글턴패턴을 쓰는 이유? -> class
// 현재 유저데이터모델 타입을 우리의 유저모델 타입으로 변환하는 방법???????????

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    private let appDelegate = UIApplication.shared.delegate as? AppDelegate

    private lazy var context = appDelegate?.persistentContainer.viewContext

    // 엔터티 이름(코어데이터에 저장된 객체)
    private let userModelName: String = "UserModel"
    private let folderModelName: String = "FolderModel"
    private let memoModelName: String = "MemoModel"
}

extension CoreDataManager {
    // MARK: - [UserCRUD]

    private func changeUserData(target: UserModel, newData: UserData) {
        target.id = newData.id
        target.nickName = newData.nickName
        target.rewardPoint = newData.rewardPoint
        target.themeColor = newData.themeColor
        target.rewardName = newData.rewardName
    }

    // MARK: - [Create] [UserCRUD]

    func createUser(newUser: UserData, completion: @escaping () -> Void) {
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: userModelName, in: context) {
                if let user = NSManagedObject(entity: entity, insertInto: context) as? UserModel {
                    changeUserData(target: user, newData: newUser)
                    appDelegate?.saveContext()
                }
            }
        }
        completion()
    }

    // MARK: - [Read] [UserCRUD]

    func getUser() -> UserData {
        var userList: [UserModel] = []

        if let context = context {
            let request = NSFetchRequest<UserModel>(entityName: userModelName)

            do {
                userList = try context.fetch(request)
            } catch {
                print("::코어데이터:: 유저 가져오기 실패!")
            }
        }

        let errorData = UserData(
            id: "error",
            nickName: "error",
            folders: [],
            memos: [],
            rewardPoint: 0,
            rewardName: "error",
            themeColor: "error"
        )

        guard let firstUser = userList.first else {
            print("CoreDataManager:", #function, ":Fail")
            print("CoreDataManager:", "Not Found First User", ":Fail")
            return errorData
        }

        let safeData = firstUser.getValue()

        return safeData
    }

    // MARK: - [Update] [UserCRUD]

    func updateUser(targetId: String, newUser: UserData, completion: @escaping () -> Void) {
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: userModelName)
            // 단서 / 찾기 위한 조건 설정
            request.predicate = NSPredicate(format: "id = %@", targetId as CVarArg)

            do {
                // 요청서를 통해서 데이터 가져오기
                if let fetchedUserDatas = try context.fetch(request) as? [UserModel] {
                    // 배열의 첫번째
                    if var targetUser = fetchedUserDatas.first {
                        changeUserData(target: targetUser, newData: newUser)
                        appDelegate?.saveContext()
                    }
                }
                completion()
            } catch {
                print("CoreDataManager:", #function, ":Fail")
                completion()
            }
        }
    }

    // MARK: - [Delete] [UserCRUD]

    func deleteUser(targetId: String, completion: @escaping () -> Void) {
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: userModelName)
            // 단서 / 찾기 위한 조건 설정
            request.predicate = NSPredicate(format: "id = %@", targetId as CVarArg)

            do {
                // 요청서를 통해서 데이터 가져오기 (조건에 일치하는 데이터 찾기) (fetch메서드)
                if let fetchedUserDatas = try context.fetch(request) as? [UserModel] {
                    // 임시저장소에서 (요청서를 통해서) 데이터 삭제하기 (delete메서드)
                    if let targetUser = fetchedUserDatas.first {
                        context.delete(targetUser)
                        appDelegate?.saveContext()
                    }
                }
                completion()
            } catch {
                print("CoreDataManager:", #function, ":Fail")
                completion()
            }
        }
    }
}

extension CoreDataManager {
    // MARK: - [FolderCRUD]

    func changeFolderData(target: FolderModel, newData: FolderData) {
        target.color = newData.color
        target.title = newData.title
        target.id = newData.id
    }

    // MARK: - [Create] [FolderCRUD]

    func createFolder(newFolder: FolderData, completion: @escaping () -> Void) {
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: folderModelName, in: context) {
                if let folder = NSManagedObject(entity: entity, insertInto: context) as? FolderModel {
                    changeFolderData(target: folder, newData: newFolder)
                    appDelegate?.saveContext()
                }
            }
        }
        completion()
    }

    // MARK: - [Read] [FolderCRUD]

    func getFolders() -> [FolderData] {
        var folderList: [FolderModel] = []

        if let context = context {
            let request = NSFetchRequest<FolderModel>(entityName: folderModelName)
            do {
                folderList = try context.fetch(request)
            } catch {
                print("::코어데이터:: 폴더 가져오기 실패!")
            }
        }
        let safeData = folderList.map { $0.getValue() }
        return safeData
    }

    // MARK: - [Update] [FolderCRUD]

    func updateFolder(targetId: String, newFolder: FolderData, completion: @escaping () -> Void) {
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: folderModelName)
            // 단서 / 찾기 위한 조건 설정
            request.predicate = NSPredicate(format: "id = %@", targetId as CVarArg)

            do {
                // 요청서를 통해서 데이터 가져오기
                if let fetchedFolderDatas = try context.fetch(request) as? [FolderModel] {
                    // 배열의 첫번째
                    if let targetFolder = fetchedFolderDatas.first {
                        changeFolderData(target: targetFolder, newData: newFolder)
                        appDelegate?.saveContext()
                    }
                }
                completion()
            } catch {
                print("CoreDataManager:", #function, ":Fail")
                completion()
            }
        }
    }

    // MARK: - [Delete] [FolderCRUD]

    func deleteFolder(targetId: String, completion: @escaping () -> Void) {
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: folderModelName)
            // 단서 / 찾기 위한 조건 설정
            request.predicate = NSPredicate(format: "id = %@", targetId as CVarArg)

            do {
                // 요청서를 통해서 데이터 가져오기 (조건에 일치하는 데이터 찾기) (fetch메서드)
                if let fetchedFolderDatas = try context.fetch(request) as? [FolderModel] {
                    // 임시저장소에서 (요청서를 통해서) 데이터 삭제하기 (delete메서드)
                    if let targetFolder = fetchedFolderDatas.first {
                        context.delete(targetFolder)
                        let targetMemos = getMemos().filter { $0.folderId == targetId }.map { $0.id }
                        for targetMemoId in targetMemos {
                            deleteMemo(targetId: targetMemoId) {
                                print(targetMemoId, "Delete")
                            }
                        }
                        appDelegate?.saveContext()
                    }
                }
                completion()
            } catch {
                print("CoreDataManager:", #function, ":Fail")
                completion()
            }
        }
    }
}

extension CoreDataManager {
    // MARK: - [MemoCRUD]

    func changeMemoData(target: MemoModel, newData: MemoData) {
        target.date = newData.date
        target.content = newData.content
        target.isPin = newData.isPin
        target.locationNotifySetting = newData.locationNotifySetting
        target.timeNotifySetting = newData.timeNotifySetting
        target.folderId = newData.folderId
        target.id = newData.id
    }

    // MARK: - [Create] [MemoCRUD]

    func createMemo(newMemo: MemoData, completion: @escaping () -> Void) {
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: memoModelName, in: context) {
                if let memo = NSManagedObject(entity: entity, insertInto: context) as? MemoModel {
                    changeMemoData(target: memo, newData: newMemo)
                    appDelegate?.saveContext()

                    // 시간 알림 설정이 있는 경우 알림을 예약
                    if let timeNotifySetting = newMemo.timeNotifySetting,
                       let date = DateFormatter.yourFormatter.date(from: timeNotifySetting) {
                        Notifications.shared.scheduleNotificationAtDate(title: "메모 알림", body: newMemo.content, date: date, identifier: newMemo.id, soundEnabled: true, vibrationEnabled: true)
                         
                    let user = getUser()
                    let yourUserData = UserData(id: user.id, nickName: user.nickName, folders: user.folders, memos: user.memos, rewardPoint: user.rewardPoint + 1, rewardName: user.rewardName, themeColor: user.themeColor)

                    updateUser(targetId: user.id, newUser: yourUserData) {
                        completion()
                    }
                }
            }
        }
    }

    // MARK: - [Read] [MemoCRUD]

    func getMemos() -> [MemoData] {
        var memoList: [MemoModel] = []

        if let context = context {
            let request = NSFetchRequest<MemoModel>(entityName: memoModelName)
            do {
                memoList = try context.fetch(request)
            } catch {
                print("::코어데이터:: 폴더 가져오기 실패!")
            }
        }
        let safeData = memoList.map { $0.getValue() }
        return safeData
    }

    // MARK: - [Update] [MemoCRUD]

    func updateMemo(updatedMemo: MemoData, completion: @escaping () -> Void) {
        if let context = context {
            let request = NSFetchRequest<MemoModel>(entityName: memoModelName)
            request.predicate = NSPredicate(format: "id = %@", updatedMemo.id as CVarArg)

            do {
                if let fetchedMemoDatas = try context.fetch(request) as? [MemoModel], let targetMemo = fetchedMemoDatas.first {
                    // 기존에 설정된 알림이 있다면 취소
                    if let existingNotifySetting = targetMemo.timeNotifySetting {
                        Notifications.shared.cancelNotification(identifier: targetMemo.id ?? "")
                    }

                    // 메모 데이터를 업데이트
                    changeMemoData(target: targetMemo, newData: updatedMemo)
                    appDelegate?.saveContext()

                    // 새로운 시간 알림 설정이 있다면 알림 예약
                    if let timeNotifySetting = updatedMemo.timeNotifySetting,
                       let date = DateFormatter.yourFormatter.date(from: timeNotifySetting) {
                        Notifications.shared.scheduleNotificationAtDate(title: "메모 알림", body: updatedMemo.content, date: date, identifier: updatedMemo.id, soundEnabled: true, vibrationEnabled: true)
                    }

                    completion()
                } else {
                    print("메모를 찾는데 실패: \(updatedMemo.id)")
                    completion()
                }
            } catch {
                print("메모 업데이트 실패:", error)
                completion()
            }
        } else {
            print("컨덱스트를 가져오는데 실패")
            completion()
        }
    }

    // MARK: - [Delete] [MemoCRUD]

    func deleteMemo(targetId: String, completion: @escaping () -> Void) {
        // 임시저장소 있는지 확인
        if let context = context {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: memoModelName)
            // 단서 / 찾기 위한 조건 설정
            request.predicate = NSPredicate(format: "id = %@", targetId as CVarArg)

            do {
                // 요청서를 통해서 데이터 가져오기 (조건에 일치하는 데이터 찾기) (fetch메서드)
                if let fetchedMemoDatas = try context.fetch(request) as? [MemoModel],
                   // 임시저장소에서 (요청서를 통해서) 데이터 삭제하기 (delete메서드)
                   let targetMemo = fetchedMemoDatas.first {
                    // 알림을 취소
                    Notifications.shared.cancelNotification(identifier: targetMemo.id ?? "")
                    context.delete(targetMemo)
                    appDelegate?.saveContext()
                }
                completion()
            } catch {
                print("CoreDataManager:", #function, ":Fail")
                completion()
            }
        }
    }
}

