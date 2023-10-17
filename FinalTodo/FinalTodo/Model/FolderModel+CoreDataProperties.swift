//
//  FileModel+CoreDataProperties.swift
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

    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var color: String
}

extension FolderModel: Identifiable {}
