//
//  FolderModel+CoreDataProperties.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/25/23.
//
//

import Foundation
import CoreData


extension FolderModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FolderModel> {
        return NSFetchRequest<FolderModel>(entityName: "FolderModel")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var color: String?

}

extension FolderModel {
    func value() -> FolderData {
        let data = FolderData(id: self.id ?? "", title: self.title ?? "", color: self.color ?? "")
        return data
    }
}

extension FolderModel : Identifiable {

}
