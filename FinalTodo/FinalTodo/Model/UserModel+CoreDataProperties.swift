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
    @NSManaged var rewardPoint: Int64
    @NSManaged var themeColor: Int64
}

extension UserModel: Identifiable {}
