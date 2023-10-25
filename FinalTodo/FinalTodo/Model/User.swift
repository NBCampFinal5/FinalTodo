//
//  Users.swift
//  FinalTodo
//
//  Created by SR on 2023/10/18.
//

import UIKit

struct User: Codable {
    let id: String
    let nickName: String
    let folders: [Folders]
    let memos: [Memos]
    let rewardPoint: Int
    let themeColor: Int
}

struct Folders: Codable {
    let id: String
    let title: String
    let color: String
}

struct Memos: Codable {
    let folderId: String
    let title: String
    let date: String
    let content: String
    let isPin: Bool
    let locationNotifySetting: String?
    let timeNotifySetting: String?
}
