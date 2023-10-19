//
//  UsersModel+CoreDataProperties.swift
//  FinalTodo
//
//  Created by SR on 2023/10/19.
//
//

import CoreData
import Foundation

public extension UsersModel {
    @nonobjc class func fetchRequest() -> NSFetchRequest<UsersModel> {
        return NSFetchRequest<UsersModel>(entityName: "UsersModel")
    }

    @NSManaged var id: String?
    @NSManaged var nickName: String?
    @NSManaged var rewardPoint: Int64
    @NSManaged var themeColor: Int64
    @NSManaged var folder: FoldersModel?
    @NSManaged var memo: MemosModel?
}

extension UsersModel: Identifiable {}
