//
//  ProfilePageViewController.swift
//  FinalTodo
//
//  Created by SR on 2023/10/12.
//

import UIKit

class ProfilePageViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        test()
    }
}

extension ProfilePageViewController {
    func setUp() {
        view.backgroundColor = .systemBackground
        title = "프로필"
    }
}

func test() {
    // 더미 데이터로 폴더, 메모, 세팅 설정
    CoreDataManager.shared.createFolder(id: "00", title: "Work", color: "Blue")
    CoreDataManager.shared.createMemo(
        content: "Finish the project",
        date: "2023-10-20",
        fileID: "123456",
        isPin: false,
        locationNotifySetting: "Office",
        timeNotifySetting: "10:00 AM",
        title: "Project Notes",
        folder: CoreDataManager.shared.fetchFolders().first ?? FolderModel()
    )
    CoreDataManager.shared.createSetting(color: "Light", font: "Helvetica")

    // Fetch and print folders
    let folders = CoreDataManager.shared.fetchFolders()
    print("Folders:")
    for folder in folders {
        print("Title: \(folder.title ?? ""), Color: \(folder.color ?? "")")
    }

    // Fetch and print memos
    let memos = CoreDataManager.shared.fetchMemos()
    print("\nMemos:")
    for memo in memos {
        print("Title: \(memo.title ?? ""), Content: \(memo.content ?? "")")
    }

    // Fetch and print settings
    let settings = CoreDataManager.shared.fetchSettings()
    print("\nSettings:")
    for setting in settings {
        print("Color: \(setting.color ?? ""), Font: \(setting.font ?? "")")
    }

    // Update a folder and a setting
    if let folderToUpdate = folders.first {
        CoreDataManager.shared.updateFolder(folderToUpdate, newTitle: "Personal", newColor: "Green")
        print("\nUpdated Folder:")
        print("Title: \(folderToUpdate.title ?? ""), Color: \(folderToUpdate.color ?? "")")
    }

    if let settingToUpdate = settings.first {
        CoreDataManager.shared.updateSetting(settingToUpdate, newColor: "Dark", newFont: "Arial")
        print("\nUpdated Setting:")
        print("Color: \(settingToUpdate.color ?? ""), Font: \(settingToUpdate.font ?? "")")
    }

    // Delete a memo
    if let memoToDelete = memos.first {
        CoreDataManager.shared.deleteMemo(memoToDelete)
        print("\nDeleted Memo:")
        print("Title: \(memoToDelete.title ?? ""), Content: \(memoToDelete.content ?? "")")
    }

    // Delete a folder
    if let folderToDelete = folders.first {
        CoreDataManager.shared.deleteFolder(folderToDelete)
        print("\nDeleted Folder:")
        print("Title: \(folderToDelete.title ?? ""), Color: \(folderToDelete.color ?? "")")
    }

    // Delete a setting
    if let settingToDelete = settings.first {
        CoreDataManager.shared.deleteSetting(settingToDelete)
        print("\nDeleted Setting:")
        print("Color: \(settingToDelete.color ?? ""), Font: \(settingToDelete.font ?? "")")
    }
}
