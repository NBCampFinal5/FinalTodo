//
//  MemoModel+CoreDataProperties.swift
//  FinalTodo
//
//  Created by SR on 2023/10/25.
//
//

import CoreData
import Foundation

public extension MemoModel {
    @nonobjc class func fetchRequest() -> NSFetchRequest<MemoModel> {
        return NSFetchRequest<MemoModel>(entityName: "MemoModel")
    }

    @NSManaged var content: String?
    @NSManaged var date: String?
    @NSManaged var folderId: String?
    @NSManaged var isPin: Bool
    @NSManaged var locationNotifySetting: String?
    @NSManaged var timeNotifySetting: String?
    @NSManaged var title: String?
}

extension MemoModel: Identifiable {}
