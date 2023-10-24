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

    @NSManaged var id: String
    @NSManaged var nickName: String
    @NSManaged var rewardPoint: Int64
    @NSManaged var themeColor: Int64
    @NSManaged var folder: NSSet?
    @NSManaged var memo: NSSet?
}

// MARK: Generated accessors for folder

public extension UsersModel {
    @objc(addFolderObject:)
    @NSManaged func addToFolder(_ value: FoldersModel)

    @objc(removeFolderObject:)
    @NSManaged func removeFromFolder(_ value: FoldersModel)

    @objc(addFolder:)
    @NSManaged func addToFolder(_ values: NSSet)

    @objc(removeFolder:)
    @NSManaged func removeFromFolder(_ values: NSSet)
}

// MARK: Generated accessors for memo

public extension UsersModel {
    @objc(addMemoObject:)
    @NSManaged func addToMemo(_ value: MemosModel)

    @objc(removeMemoObject:)
    @NSManaged func removeFromMemo(_ value: MemosModel)

    @objc(addMemo:)
    @NSManaged func addToMemo(_ values: NSSet)

    @objc(removeMemo:)
    @NSManaged func removeFromMemo(_ values: NSSet)
}

extension UsersModel: Identifiable {}
