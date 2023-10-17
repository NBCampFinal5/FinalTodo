//
//  MemoModel+CoreDataProperties.swift
//  FinalTodo
//
//  Created by SR on 2023/10/18.
//
//

import Foundation
import CoreData


extension MemoModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoModel> {
        return NSFetchRequest<MemoModel>(entityName: "MemoModel")
    }

    @NSManaged public var content: String?
    @NSManaged public var date: String?
    @NSManaged public var fileID: String?
    @NSManaged public var isPin: Bool
    @NSManaged public var locationNotifySetting: String?
    @NSManaged public var timeNotifySetting: String?
    @NSManaged public var title: String?
    @NSManaged public var folder: FolderModel?

}

extension MemoModel : Identifiable {

}
