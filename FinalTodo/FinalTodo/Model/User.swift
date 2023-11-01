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
    let nickName: String
    let folders: [FolderData]
    let memos: [MemoData]
    let rewardPoint: Int32
    let rewardName: String
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
    var tags: String? // 태그를 저장할 새로운 속성
}
