//
//  FoldersModel+CoreDataProperties.swift
//  FinalTodo
//
//  Created by SR on 2023/10/19.
//
//

import CoreData
import Foundation

public extension FoldersModel {
    @nonobjc class func fetchRequest() -> NSFetchRequest<FoldersModel> {
        return NSFetchRequest<FoldersModel>(entityName: "FoldersModel")
    }

    @NSManaged var color: Int64
    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var memo: NSSet?
    @NSManaged var user: UsersModel
}

// MARK: Generated accessors for memo

public extension FoldersModel {
    @objc(addMemoObject:)
    @NSManaged func addToMemo(_ value: MemosModel)

    @objc(removeMemoObject:)
    @NSManaged func removeFromMemo(_ value: MemosModel)

    @objc(addMemo:)
    @NSManaged func addToMemo(_ values: NSSet)

    @objc(removeMemo:)
    @NSManaged func removeFromMemo(_ values: NSSet)
}

extension FoldersModel: Identifiable {}
