//
//  FolderModel+CoreDataProperties.swift
//  FinalTodo
//
//  Created by SR on 2023/10/18.
//
//

import Foundation
import CoreData


extension FolderModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FolderModel> {
        return NSFetchRequest<FolderModel>(entityName: "FolderModel")
    }

    @NSManaged public var color: String?
    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var memo: NSSet?

}

// MARK: Generated accessors for memo
extension FolderModel {

    @objc(addMemoObject:)
    @NSManaged public func addToMemo(_ value: MemoModel)

    @objc(removeMemoObject:)
    @NSManaged public func removeFromMemo(_ value: MemoModel)

    @objc(addMemo:)
    @NSManaged public func addToMemo(_ values: NSSet)

    @objc(removeMemo:)
    @NSManaged public func removeFromMemo(_ values: NSSet)

}

extension FolderModel : Identifiable {

}
