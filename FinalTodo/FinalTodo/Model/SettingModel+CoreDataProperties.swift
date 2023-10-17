//
//  SettingModel+CoreDataProperties.swift
//  FinalTodo
//
//  Created by SR on 2023/10/18.
//
//

import CoreData
import Foundation

public extension SettingModel {
    @nonobjc class func fetchRequest() -> NSFetchRequest<SettingModel> {
        return NSFetchRequest<SettingModel>(entityName: "SettingModel")
    }

    @NSManaged var color: String?
    @NSManaged var font: String?
}

extension SettingModel: Identifiable {}
