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
import FirebaseAuth

class CoreDataManager {
    static let shared = CoreDataManager()
    let firebaseManager = FirebaseDBManager.shared
    
    private init() {}
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    private lazy var context = appDelegate?.persistentContainer.viewContext
    
    // 엔터티 이름(코어데이터에 저장된 객체)
    private let userModelName: String = "UserModel"
    private let folderModelName: String = "FolderModel"
    private let memoModelName: String = "MemoModel"
    
}

extension CoreDataManager {
    
    func fetchUser() -> UserData {
        var userData = getUser()
        let folderData = getFolders()
        let memoData = getMemos()
        userData.folders.append(contentsOf: folderData)
        userData.memos.append(contentsOf: memoData)
        return userData
    }
    
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
        // Context가 유효한지 확인
        guard let context = context else {
            print("::코어데이터:: Context가 nil 입니다.")
            return UserData.errorData() // 오류 데이터 반환
        }
        
        let request = NSFetchRequest<UserModel>(entityName: userModelName)
        request.fetchLimit = 1 // 첫 번째 객체만 가져옴
        
        do {
            // 요청 실행
            if let user = try context.fetch(request).first {
                // UserModel에서 UserData로 변환
                return user.getValue()
            } else {
                print("CoreDataManager:", #function, ": 사용자 데이터 없음")
            }
        } catch {
            print("::코어데이터:: 유저 가져오기 실패:", error)
        }
        
        // 에러 데이터 반환
        return UserData.errorData()
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
    
    func deleteAllUsers(completion: @escaping () -> Void) {
        guard let context = context else {
            print("::코어데이터:: Context가 nil 입니다.")
            completion()
            return
        }
        
        // 요청서를 만들고, UserModel에 대한 요청임을 명시합니다.
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: userModelName)
        
        // 배치 삭제 요청을 생성합니다.
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            // 배치 삭제 요청을 실행합니다.
            try context.execute(batchDeleteRequest)
            
            // 컨텍스트의 변경사항을 영속적인 저장소에 반영합니다.
            appDelegate?.saveContext()
            
            print("CoreDataManager: 모든 사용자 데이터가 삭제되었습니다.")
            completion()
        } catch {
            print("CoreDataManager:", #function, ": 실패 -", error)
            completion()
        }
    }
    
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
    
    func fetchFolder(completion: @escaping () -> Void) {
        print("시작: 폴더 데이터 가져오기 시작")
        FirebaseDBManager.shared.fetchFolderData { (folderDataArray, error) in
            print("완료: 폴더 데이터 가져오기 완료")
            guard let context = self.context else {
                print("코어데이터 컨텍스트가 nil 입니다.")
                return
            }
            
            guard let folderDataArray = folderDataArray, error == nil else {
                print("폴더 데이터 가져오기 실패: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // 기존의 모든 폴더 삭제
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FolderModel")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                // 새로운 폴더 생성 및 저장
                for folderData in folderDataArray {
                    let newFolder = FolderModel(context: context)
                    newFolder.id = folderData.id
                    newFolder.title = folderData.title
                    newFolder.color = folderData.color
                }
                try context.save()
                completion()
            } catch {
                print("코어데이터에 새 폴더 저장 실패: \(error.localizedDescription)")
                debugPrint(error)
            }
        }
    }
    
    private func fetchAndPrintFolders(in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<FolderModel> = FolderModel.fetchRequest()
        
        do {
            let folders = try context.fetch(fetchRequest)
            for folder in folders {
                print("Folder ID: \(folder.id ?? "Unknown"), Title: \(folder.title ?? "No Title"), Color: \(folder.color ?? "No Color")")
            }
        } catch {
            print("폴더 조회 실패: \(error.localizedDescription)")
        }
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
    
    func fetchMemo(completion: @escaping () -> Void) {
        print("시작: memo 데이터 가져오기 시작")
        FirebaseDBManager.shared.fetchMemos { (memoDataArray, error) in
            print("완료: 폴더 데이터 가져오기 완료")
            guard let context = self.context else {
                print("코어데이터 컨텍스트가 nil 입니다.")
                return
            }
            
            guard let memoDataArray = memoDataArray, error == nil else {
                print("메모 데이터 가져오기 실패: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // 기존의 모든 메모 삭제
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MemoModel")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                // 새로운 메모 생성 및 저장
                for memoData in memoDataArray {
                    let newMemo = MemoModel(context: context)
                    newMemo.id = memoData.id
                    newMemo.content = memoData.content
                    newMemo.date = memoData.date
                    newMemo.folderId = memoData.folderId
                    newMemo.isPin = memoData.isPin
                    newMemo.locationNotifySetting = memoData.locationNotifySetting
                    newMemo.timeNotifySetting = memoData.timeNotifySetting
                }
                try context.save()
                print("메모 데이터 저장 완료")
                completion()
            } catch {
                print("메모 업데이트 실패: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - [Create] [MemoCRUD]
    
    func createMemo(newMemo: MemoData, completion: @escaping () -> Void) {
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: memoModelName, in: context) {
                if let memo = NSManagedObject(entity: entity, insertInto: context) as? MemoModel {
                    changeMemoData(target: memo, newData: newMemo)
                    appDelegate?.saveContext()
                    
                    // 성준 - 시간 알림 설정이 있는 경우 알림을 예약
                    if let timeNotifySetting = newMemo.timeNotifySetting,
                       let date = DateFormatter.yourFormatter.date(from: timeNotifySetting)
                    {
                        Notifications.shared.scheduleNotificationAtDate(title: "메모 알림", body: newMemo.content, date: date, identifier: newMemo.id, soundEnabled: true, vibrationEnabled: true)
                    }
                    
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
                    // 성준 - 기존에 설정된 알림이 있다면 취소
                    if let existingNotifySetting = targetMemo.timeNotifySetting {
                        Notifications.shared.cancelNotification(identifier: targetMemo.id ?? "")
                    }

                    changeMemoData(target: targetMemo, newData: updatedMemo)
                    appDelegate?.saveContext()

                    // 성준 - 새로운 시간 알림 설정이 있다면 알림 예약
                    if let timeNotifySetting = updatedMemo.timeNotifySetting,
                       let date = DateFormatter.yourFormatter.date(from: timeNotifySetting)
                    {
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
                   let targetMemo = fetchedMemoDatas.first
                {
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

extension CoreDataManager {
    
    func deleteAllData(completion: (() -> Void)? = nil) {
        deleteAllUsers()
        deleteAllMemos()
        deleteAllFolders()
        completion?()
    }
    
    func deleteAllUsers() {
        guard let context = self.context else { return }
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: userModelName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let error as NSError {
            // 에러 핸들링
            print("Deleting all users error: \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllMemos() {
        guard let context = self.context else { return }
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: memoModelName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let error as NSError {
            // 에러 핸들링
            print("Deleting all memos error: \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllFolders() {
        guard let context = self.context else { return }
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: folderModelName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let error as NSError {
            // 에러 핸들링
            print("Deleting all folders error: \(error), \(error.userInfo)")
        }
    }
}



extension UserData {
    static func errorData() -> UserData {
        return UserData(
            id: "error",
            nickName: "error",
            folders: [],
            memos: [],
            rewardPoint: 0,
            rewardName: "error",
            themeColor: "error"
        )
    }
}


