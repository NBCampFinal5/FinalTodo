//
//  MemoModel+CoreDataProperties.swift
//  FinalTodo
//
//  Created by SeoJunYoung on 10/25/23.
//
//

import Foundation
import CoreData


extension MemoModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoModel> {
        return NSFetchRequest<MemoModel>(entityName: "MemoModel")
    }

    @NSManaged public var folderId: String?
    @NSManaged public var title: String?
    @NSManaged public var date: String?
    @NSManaged public var content: String?
    @NSManaged public var isPin: Bool
    @NSManaged public var locationNotifySetting: String?
    @NSManaged public var timeNotifySetting: String?
    @NSManaged public var memoId: String?

}
extension MemoModel {
    func value() -> MemoData {
        let data = MemoData(
            folderId: self.folderId ?? "",
            memoId: self.memoId ?? "",
            title: self.title ?? "",
            date: self.date ?? "",
            content: self.content ?? "",
            isPin: self.isPin,
            locationNotifySetting: self.locationNotifySetting,
            timeNotifySetting: self.timeNotifySetting)
        return data
    }
}

extension MemoModel : Identifiable {

}
