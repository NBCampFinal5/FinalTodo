//
//  Users.swift
//  FinalTodo
//
//  Created by SR on 2023/10/18.
//

import UIKit

struct Users: Codable {
    let id: String
    let nickName: String
    let folders: [Folders]
    let memoDatas: [Memos]
    let rewardPoint: Int
    let settingValue: SettingValues
}

struct Folders: Codable {
    let id: String
    let name: String
    let color: String
}

struct Memos: Codable {
    let Fileid: String
    let title: String
    let date: String
    let content: String
    let isPin: Bool
    let locationNotifySetting: String?
    let timeNotifySetting: String?
}

struct SettingValues: Codable {
    let color: String
    let font: String
}
