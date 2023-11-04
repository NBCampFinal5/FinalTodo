//
//  Users.swift
//  FinalTodo
//
//  Created by SR on 2023/10/18.
//

import CoreData
import UIKit

struct UserData: Codable {
    let id: String
    var nickName: String
    var folders: [FolderData]
    var memos: [MemoData]
    var rewardPoint: Int32
    var rewardName: String
    let themeColor: String
}

struct FolderData: Codable {
    let id: String
    let title: String
    let color: String
}

struct MemoData: Codable {
    let id: String
    let folderId: String
    let date: String
    let content: String
    let isPin: Bool
    let locationNotifySetting: String?
    let timeNotifySetting: String?
    var notificationDate: Date? // 알림 날짜 및 시간 추가
}
