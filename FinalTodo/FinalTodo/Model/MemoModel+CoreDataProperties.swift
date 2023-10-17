//
//  MemoModel+CoreDataProperties.swift
//  FinalTodo
//
//  Created by SR on 2023/10/18.
//
//

import CoreData
import UIKit

public extension MemoModel {
    @nonobjc class func fetchRequest() -> NSFetchRequest<MemoModel> {
        return NSFetchRequest<MemoModel>(entityName: "MemoModel")
    }

    @NSManaged var title: String
    @NSManaged var content: String
    @NSManaged var date: String
    @NSManaged var fileID: String
    @NSManaged var locationNotifySetting: String?
    @NSManaged var timeNotifySetting: String?
    @NSManaged var isPin: Bool
}

extension MemoModel: Identifiable {}
