//
//  CoreDataManager.swift
//  FinalTodo
//
//  Created by SR on 2023/10/18.
//

import CoreData
import UIKit

final class CoreDataManager {
    
    // 싱글톤으로 만들기
    static let shared = CoreDataManager()
    private init() {}
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var memoContext = appDelegate?.memoPersistentContainer.viewContext
    private lazy var folderContext = appDelegate?.folderPersistentContainer.viewContext
    private let memoModel = "MemoModel"
    private let folderModel = "FolderModel"
    private let userModel = "UserModel"
    
    deinit { print("CoredataManager deinit") }
}

extension CoreDataManager {
    // [MemoCRUD]
    // MARK: - [Read] [MemoCRUD]
    func getAllMemoDatas() -> [MemoData] {
        var memoDatas: [MemoData] = []
        // 임시저장소 있는지 확인
        if let context = memoContext {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: self.memoModel)
            
            do {
                // 임시저장소에서 (요청서를 통해서) 데이터 가져오기 (fetch메서드)
                if let fetchedMemoDatas = try context.fetch(request) as? [MemoModel] {
                    memoDatas = fetchedMemoDatas.map{$0.value()}
                }
            } catch {
                print("CoreDataManager:",#function,":Fail")
            }
        }
        return memoDatas
    }
    
    // MARK: - [Create] [MemoCRUD]
    func createMemo(memo: MemoData, completion: @escaping () -> Void) {
        // 임시저장소 있는지 확인
        if let context = memoContext {
            // 임시저장소에 있는 데이터를 그려줄 형태 파악하기
            if let entity = NSEntityDescription.entity(forEntityName: self.memoModel, in: context) {

                // 임시저장소에 올라가게 할 객체만들기
                if let memoData = NSManagedObject(entity: entity, insertInto: context) as? MemoModel {

                    // 실제 데이터 할당
                    changeMemo(targetMemo: memoData, newMemo: memo)
                    appDelegate?.saveMemo()
                }
            }
        }
        completion()
    }
    
    // MARK: - [Update] [MemoCRUD]
    func updateMemo(targetId: String, newMemo: MemoData, completion: @escaping () -> Void) {

        
        // 임시저장소 있는지 확인
        if let context = memoContext {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: self.memoModel)
            // 단서 / 찾기 위한 조건 설정
            request.predicate = NSPredicate(format: "memoId = %@", targetId as CVarArg)
            
            do {
                // 요청서를 통해서 데이터 가져오기
                if let fetchedMemoDatas = try context.fetch(request) as? [MemoModel] {
                    // 배열의 첫번째
                    if var targetMemo = fetchedMemoDatas.first {
                        
                        // 실제 데이터 재할당
                        changeMemo(targetMemo: targetMemo, newMemo: newMemo)
                        appDelegate?.saveMemo()
                    }
                }
                completion()
            } catch {
                print("CoreDataManager:",#function,":Fail")
                completion()
            }
        }
    }
    
    // MARK: - [Delete] [MemoCRUD]
    func deleteMemo(targetId: String, completion: @escaping () -> Void) {
        
        // 임시저장소 있는지 확인
        if let context = memoContext {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: self.memoModel)
            // 단서 / 찾기 위한 조건 설정
            request.predicate = NSPredicate(format: "memoId = %@", targetId as CVarArg)
            
            do {
                // 요청서를 통해서 데이터 가져오기 (조건에 일치하는 데이터 찾기) (fetch메서드)
                if let fetchedMemoDatas = try context.fetch(request) as? [MemoModel] {
                    
                    // 임시저장소에서 (요청서를 통해서) 데이터 삭제하기 (delete메서드)
                    if let targetMemo = fetchedMemoDatas.first {
                        context.delete(targetMemo)
                        
                        appDelegate?.saveMemo()
                    }
                }
                completion()
            } catch {
                print("CoreDataManager:",#function,":Fail")
                completion()
            }
        }
    }

    private func changeMemo(targetMemo: MemoModel, newMemo: MemoData) {
        targetMemo.content = newMemo.content
        targetMemo.date = newMemo.date
        targetMemo.folderId = newMemo.folderId
        targetMemo.isPin = newMemo.isPin
        targetMemo.memoId = newMemo.memoId
        targetMemo.locationNotifySetting = newMemo.locationNotifySetting
        targetMemo.timeNotifySetting = newMemo.timeNotifySetting
    }
}


extension CoreDataManager {
    
    // [FolderCRUD]
    // MARK: - [Read] [FolderCRUD]
    func getAllFolder() -> [FolderData] {
        var folderDatas: [FolderData] = []
        // 임시저장소 있는지 확인
        if let context = folderContext {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: self.folderModel)
            
            do {
                // 임시저장소에서 (요청서를 통해서) 데이터 가져오기 (fetch메서드)
                if let fetchedMemoDatas = try context.fetch(request) as? [FolderModel] {
                    folderDatas = fetchedMemoDatas.map{$0.value()}
                }
            } catch {
                print("CoreDataManager:",#function,":Fail")
            }
        }
        return folderDatas
    }
    
    // MARK: - [Create] [FolderCRUD]
    func createFolder(folder: FolderData, completion: @escaping () -> Void) {
        // 임시저장소 있는지 확인
        if let context = folderContext {
            // 임시저장소에 있는 데이터를 그려줄 형태 파악하기
            if let entity = NSEntityDescription.entity(forEntityName: self.folderModel, in: context) {

                // 임시저장소에 올라가게 할 객체만들기
                if let folderData = NSManagedObject(entity: entity, insertInto: context) as? FolderModel {

                    // 실제 데이터 할당
                    changeFolder(targetFolder: folderData, newFolder: folder)
                    appDelegate?.saveFolder()
                }
            }
        }
        completion()
    }
    
    // MARK: - [Update] [FolderCRUD]
    func updateFolder(targetId: String, newFolder: FolderData, completion: @escaping () -> Void) {

        
        // 임시저장소 있는지 확인
        if let context = folderContext {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: self.folderModel)
            // 단서 / 찾기 위한 조건 설정
            request.predicate = NSPredicate(format: "id = %@", targetId as CVarArg)
            
            do {
                // 요청서를 통해서 데이터 가져오기
                if let fetchedFolderDatas = try context.fetch(request) as? [FolderModel] {
                    // 배열의 첫번째
                    if var targetFolder = fetchedFolderDatas.first {
                        
                        // 실제 데이터 재할당
                        changeFolder(targetFolder: targetFolder, newFolder: newFolder)
                        appDelegate?.saveFolder()
                    }
                }
                completion()
            } catch {
                print("CoreDataManager:",#function,":Fail")
                completion()
            }
        }
    }
    
    // MARK: - [Delete] [FolderCRUD]
    func deleteFolder(targetId: String, completion: @escaping () -> Void) {
        
        // 임시저장소 있는지 확인
        if let context = folderContext {
            // 요청서
            let request = NSFetchRequest<NSManagedObject>(entityName: self.folderModel)
            // 단서 / 찾기 위한 조건 설정
            request.predicate = NSPredicate(format: "id = %@", targetId as CVarArg)
            
            do {
                // 요청서를 통해서 데이터 가져오기 (조건에 일치하는 데이터 찾기) (fetch메서드)
                if let fetchedFolderDatas = try context.fetch(request) as? [FolderModel] {
                    
                    // 임시저장소에서 (요청서를 통해서) 데이터 삭제하기 (delete메서드)
                    if let targetFolder = fetchedFolderDatas.first {
                        context.delete(targetFolder)
                        
                        appDelegate?.saveFolder()
                    }
                }
                completion()
            } catch {
                print("CoreDataManager:",#function,":Fail")
                completion()
            }
        }
    }

    private func changeFolder(targetFolder: FolderModel, newFolder: FolderData) {
        targetFolder.id = newFolder.id
        targetFolder.title = newFolder.title
        targetFolder.color = newFolder.color
    }
    
}

extension CoreDataManager {
    // MARK: - UserCRUD

}
