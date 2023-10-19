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
    @NSManaged var id: String?
    @NSManaged var title: String?
    @NSManaged var memo: MemosModel?
    @NSManaged var user: UsersModel?
}

extension FoldersModel: Identifiable {}
