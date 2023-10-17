//
//  SettingModel+CoreDataProperties.swift
//  FinalTodo
//
//  Created by SR on 2023/10/18.
//
//

import Foundation
import CoreData


extension SettingModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SettingModel> {
        return NSFetchRequest<SettingModel>(entityName: "SettingModel")
    }

    @NSManaged public var color: String?
    @NSManaged public var font: String?

}

extension SettingModel : Identifiable {

}
