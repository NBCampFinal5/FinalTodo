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

    private let memoEntityName: String = "MemoModel"
    private let settingEntityName: String = "SettingModel"
    private let folderEntityName: String = "FolderModel"

    // MARK: - Helper Methods

    private func saveContext() {
        do {
            try context?.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}

// 폴더데이터 CRUD
extension CoreDataManager {
    func createFolder(id: String, title: String, color: String) {
        guard let context = context,
              let entity = NSEntityDescription.entity(forEntityName: "FolderModel", in: context),
              let folder = NSManagedObject(entity: entity, insertInto: context) as? FolderModel
        else {
            return
        }
        folder.id = id
        folder.title = title
        folder.color = color
        saveContext()
    }

    func fetchFolders() -> [FolderModel] {
        guard let context = context else {
            return []
        }
        let fetchRequest = NSFetchRequest<FolderModel>(entityName: "FolderModel")
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch folders: \(error.localizedDescription)")
            return []
        }
    }

    func updateFolder(_ folder: FolderModel, newTitle: String, newColor: String) {
        folder.title = newTitle
        folder.color = newColor
        saveContext()
    }

    func deleteFolder(_ folder: FolderModel) {
        guard let context = context else {
            return
        }
        context.delete(folder)
        saveContext()
    }
}

// 메모데이터 CRUD
extension CoreDataManager {
    func createMemo(content: String, date: String, fileID: String, isPin: Bool, locationNotifySetting: String, timeNotifySetting: String, title: String, folder: FolderModel) {
        guard let context = context,
              let entity = NSEntityDescription.entity(forEntityName: "MemoModel", in: context),
              let memo = NSManagedObject(entity: entity, insertInto: context) as? MemoModel
        else {
            return
        }
        memo.content = content
        memo.date = date
        memo.fileID = fileID
        memo.isPin = isPin
        memo.locationNotifySetting = locationNotifySetting
        memo.timeNotifySetting = timeNotifySetting
        memo.title = title
        memo.folder = folder
        saveContext()
    }

    func fetchMemos() -> [MemoModel] {
        guard let context = context else {
            return []
        }
        let fetchRequest = NSFetchRequest<MemoModel>(entityName: "MemoModel")
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch memos: \(error.localizedDescription)")
            return []
        }
    }

    func updateMemo(_ memo: MemoModel, newContent: String, newDate: String, newFileID: String, newIsPin: Bool, newLocationNotifySetting: String, newTimeNotifySetting: String, newTitle: String, newFolder: FolderModel) {
        memo.content = newContent
        memo.date = newDate
        memo.fileID = newFileID
        memo.isPin = newIsPin
        memo.locationNotifySetting = newLocationNotifySetting
        memo.timeNotifySetting = newTimeNotifySetting
        memo.title = newTitle
        memo.folder = newFolder
        saveContext()
    }

    func deleteMemo(_ memo: MemoModel) {
        guard let context = context else {
            return
        }
        context.delete(memo)
        saveContext()
    }
}

// 세팅데이터 CRUD
extension CoreDataManager {
    func createSetting(color: String, font: String) {
        guard let context = context,
              let entity = NSEntityDescription.entity(forEntityName: "SettingModel", in: context),
              let setting = NSManagedObject(entity: entity, insertInto: context) as? SettingModel
        else {
            return
        }
        setting.color = color
        setting.font = font
        saveContext()
    }

    func fetchSettings() -> [SettingModel] {
        guard let context = context else {
            return []
        }
        let fetchRequest = NSFetchRequest<SettingModel>(entityName: "SettingModel")
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch settings: \(error.localizedDescription)")
            return []
        }
    }

    func updateSetting(_ setting: SettingModel, newColor: String, newFont: String) {
        setting.color = newColor
        setting.font = newFont
        saveContext()
    }

    func deleteSetting(_ setting: SettingModel) {
        guard let context = context else {
            return
        }
        context.delete(setting)
        saveContext()
    }
}
