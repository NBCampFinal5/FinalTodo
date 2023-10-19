//
//  MemosModel+CoreDataProperties.swift
//  FinalTodo
//
//  Created by SR on 2023/10/19.
//
//

import CoreData
import Foundation

public extension MemosModel {
    @nonobjc class func fetchRequest() -> NSFetchRequest<MemosModel> {
        return NSFetchRequest<MemosModel>(entityName: "MemosModel")
    }

    @NSManaged var content: String?
    @NSManaged var date: String?
    @NSManaged var fileId: String?
    @NSManaged var isPin: Bool
    @NSManaged var locationNotifySetting: String?
    @NSManaged var timeNotifySetting: String?
    @NSManaged var title: String?
    @NSManaged var folder: FoldersModel?
    @NSManaged var user: UsersModel?
}

extension MemosModel: Identifiable {}
