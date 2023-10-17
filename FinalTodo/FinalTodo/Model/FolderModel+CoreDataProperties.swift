//
//  FolderModel+CoreDataProperties.swift
//  FinalTodo
//
//  Created by SR on 2023/10/18.
//
//

import CoreData
import Foundation

public extension FolderModel {
    @nonobjc class func fetchRequest() -> NSFetchRequest<FolderModel> {
        return NSFetchRequest<FolderModel>(entityName: "FolderModel")
    }

    @NSManaged var color: String?
    @NSManaged var id: String?
    @NSManaged var title: String?
    @NSManaged var memo: NSSet?
}

// MARK: Generated accessors for memo

public extension FolderModel {
    @objc(addMemoObject:)
    @NSManaged func addToMemo(_ value: MemoModel)

    @objc(removeMemoObject:)
    @NSManaged func removeFromMemo(_ value: MemoModel)

    @objc(addMemo:)
    @NSManaged func addToMemo(_ values: NSSet)

    @objc(removeMemo:)
    @NSManaged func removeFromMemo(_ values: NSSet)
}

extension FolderModel: Identifiable {}
