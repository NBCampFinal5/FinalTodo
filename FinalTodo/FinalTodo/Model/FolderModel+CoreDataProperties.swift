//
//  FolderModel+CoreDataProperties.swift
//  FinalTodo
//
//  Created by SR on 2023/10/25.
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
}

extension FolderModel: Identifiable {}
