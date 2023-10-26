//
//  UserModel+CoreDataProperties.swift
//  FinalTodo
//
//  Created by SR on 2023/10/25.
//
//

import CoreData
import Foundation

public extension UserModel {
    @nonobjc class func fetchRequest() -> NSFetchRequest<UserModel> {
        return NSFetchRequest<UserModel>(entityName: "UserModel")
    }

    @NSManaged var id: String?
    @NSManaged var nickName: String?
    @NSManaged var rewardPoint: Int32
    @NSManaged var themeColor: String?
    @NSManaged var rewardName: String?
}

extension UserModel: Identifiable {}

extension UserModel {
    func getValue() -> UserData {
        var userData = UserData(
            id: self.id ?? "",
            nickName: self.nickName ?? "",
            folders: [],
            memos: [],
            rewardPoint: self.rewardPoint,
            rewardName: self.rewardName ?? "",
            themeColor: self.themeColor ?? ""
        )
        return userData
    }
}
