//
//  Users.swift
//  FinalTodo
//
//  Created by SR on 2023/10/18.
//

import UIKit

struct UserData: Codable {
    let id: String
    let nickName: String
    let folders: [FolderData]
    let memos: [MemoData]
    let rewardPoint: Int
    let themeColor: Int
}

struct FolderData: Codable {
    let id: String
    let title: String
    let color: String
}

struct MemoData: Codable {
    let folderId: String
    let memoId: String
    let title: String
    let date: String
    let content: String
    let isPin: Bool
    let locationNotifySetting: String?
    let timeNotifySetting: String?
}

