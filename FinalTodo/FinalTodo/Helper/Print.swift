//
//  Print.swift
//  FinalTodo
//
//  Created by Jongbum Lee on 2023/11/03.
//

import Foundation

class PrintDetails {
    func show(of object: Any) {
        let mirror = Mirror(reflecting: object)
        for child in mirror.children {
            if let propertyName = child.label {
                print("\(propertyName): \(child.value)")
            }
        }
    }
}
