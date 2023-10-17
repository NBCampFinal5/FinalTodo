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
    
    let memoEntityName: String = "MemoModel"
    let settingEntityName: String = "SettingModel"
    let folderEntityName: String = "FolderModel"
    
    // MARK: - Memo CRUD

    func createMemo(fileID: String, title: String, date: String, content: String, isPin: Bool, locationNotifySetting: String?, timeNotifySetting: String?) {
        if let context = context, let entity = NSEntityDescription.entity(forEntityName: memoEntityName, in: context) {
            let memo = NSManagedObject(entity: entity, insertInto: context) as! MemoModel
            
            memo.fileID = fileID
            memo.title = title
            memo.date = date
            memo.content = content
            memo.isPin = isPin
            memo.locationNotifySetting = locationNotifySetting
            memo.timeNotifySetting = timeNotifySetting
            
            saveContext()
        }
    }
    
    func getMemos() -> [MemoModel] {
        if let context = context {
            let request = NSFetchRequest<MemoModel>(entityName: memoEntityName)
            do {
                return try context.fetch(request)
            } catch {
                print("Memo 조회 실패: \(error.localizedDescription)")
            }
        }
        return []
    }
    
    func updateMemo(memo: MemoModel, newTitle: String, newContent: String, newIsPin: Bool, newLocationNotifySetting: String?, newTimeNotifySetting: String?) {
        memo.title = newTitle
        memo.content = newContent
        memo.isPin = newIsPin
        memo.locationNotifySetting = newLocationNotifySetting
        memo.timeNotifySetting = newTimeNotifySetting
        saveContext()
    }
    
    func deleteMemo(memo: MemoModel) {
        if let context = context {
            context.delete(memo)
            saveContext()
        }
    }
    
    // MARK: - Setting CRUD

    func createSetting(color: String, font: String) {
        if let context = context, let entity = NSEntityDescription.entity(forEntityName: settingEntityName, in: context), let setting = NSManagedObject(entity: entity, insertInto: context) as? SettingModel {
            setting.color = color
            setting.font = font
            saveContext()
        }
    }
    
    func getSettings() -> [SettingModel] {
        if let context = context {
            let request = NSFetchRequest<SettingModel>(entityName: settingEntityName)
            do {
                return try context.fetch(request)
            } catch {
                print("설정 조회 실패: \(error.localizedDescription)")
            }
        }
        return []
    }
    
    func updateSetting(setting: SettingModel, newColor: String, newFont: String) {
        setting.color = newColor
        setting.font = newFont
        saveContext()
    }

    func deleteSetting(setting: SettingModel) {
        if let context = context {
            context.delete(setting)
            saveContext()
        }
    }
    
    // MARK: - Folder CRUD

    func createFolder(title: String, color: String) {
        if let context = context, let entity = NSEntityDescription.entity(forEntityName: folderEntityName, in: context), let folder = NSManagedObject(entity: entity, insertInto: context) as? FolderModel {
            folder.title = title
            folder.color = color
            saveContext()
        }
    }
    
    func getFolders() -> [FolderModel] {
        if let context = context {
            let request = NSFetchRequest<FolderModel>(entityName: folderEntityName)
            do {
                return try context.fetch(request)
            } catch {
                print("폴더 조회 실패: \(error.localizedDescription)")
            }
        }
        return []
    }
    
    func updateFolder(folder: FolderModel, newTitle: String, newColor: String) {
        folder.title = newTitle
        folder.color = newColor
        saveContext()
    }
    
    func deleteFolder(folder: FolderModel) {
        if let context = context {
            context.delete(folder)
            saveContext()
        }
    }
    
    private func saveContext() {
        if let context = context {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print("컨텍스트 저장 실패: \(error.localizedDescription)")
                }
            }
        }
    }
}

// CoreDataManager.shared.사용을 원하는 메서드() -> 이렇게 사용해 주시면 됩니다! 추가 구현이 필요한 메서드 요청해 주세요.
// 로컬에서는 아예 User 정보가 필요 없어서, 파이어베이스와 폴더, 메모, 세팅 정보만 주고 받는 방식으로 구현하였습니다.
// NetworkManager(User Struct) <-> DataManager <-> CoreDataManager(CoreData class)
